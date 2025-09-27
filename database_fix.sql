-- MANUAL FIX FOR DATABASE TYPE MISMATCH
-- Run this SQL in your Supabase dashboard to fix the conversation function

-- Drop the old function first
DROP FUNCTION IF EXISTS get_user_conversations(UUID, TIMESTAMPTZ, INTEGER);

-- Recreate with correct types
CREATE OR REPLACE FUNCTION get_user_conversations(
  user_uuid UUID,
  cursor_timestamp TIMESTAMPTZ DEFAULT now(),
  page_limit INTEGER DEFAULT 30
)
RETURNS TABLE (
  partner_id UUID,
  partner_username VARCHAR(30),
  partner_full_name VARCHAR(100), 
  partner_avatar_url TEXT,
  last_message_content TEXT,
  last_message_timestamp TIMESTAMPTZ,
  unread_count BIGINT
) AS $$
BEGIN
  RETURN QUERY
  WITH conversation_partners AS (
    SELECT DISTINCT
      CASE 
        WHEN m.sender_id = user_uuid THEN m.recipient_id
        ELSE m.sender_id
      END as partner_user_id
    FROM messages m
    WHERE m.sender_id = user_uuid OR m.recipient_id = user_uuid
  ),
  latest_messages AS (
    SELECT DISTINCT ON (
      CASE 
        WHEN m.sender_id = user_uuid THEN m.recipient_id
        ELSE m.sender_id
      END
    )
      CASE 
        WHEN m.sender_id = user_uuid THEN m.recipient_id
        ELSE m.sender_id
      END as partner_user_id,
      m.content as last_content,
      m.created_at as last_timestamp
    FROM messages m
    WHERE m.sender_id = user_uuid OR m.recipient_id = user_uuid
    ORDER BY 
      CASE 
        WHEN m.sender_id = user_uuid THEN m.recipient_id
        ELSE m.sender_id
      END,
      m.created_at DESC
  ),
  unread_counts AS (
    SELECT 
      m.sender_id as partner_user_id,
      COUNT(*) as unread_count
    FROM messages m
    WHERE m.recipient_id = user_uuid 
      AND m.read = false
    GROUP BY m.sender_id
  )
  SELECT 
    cp.partner_user_id,
    p.username,
    p.full_name,
    p.avatar_url,
    lm.last_content,
    lm.last_timestamp,
    COALESCE(uc.unread_count, 0) as unread_count
  FROM conversation_partners cp
  LEFT JOIN profiles p ON p.id = cp.partner_user_id
  LEFT JOIN latest_messages lm ON lm.partner_user_id = cp.partner_user_id
  LEFT JOIN unread_counts uc ON uc.partner_user_id = cp.partner_user_id
  WHERE lm.last_timestamp IS NOT NULL
    AND lm.last_timestamp < cursor_timestamp
  ORDER BY lm.last_timestamp DESC
  LIMIT page_limit;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION get_user_conversations(UUID, TIMESTAMPTZ, INTEGER) TO authenticated;