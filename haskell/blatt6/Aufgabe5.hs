data Rose a = Rose a [Rose a]


instance Eq Rose where
(==) 