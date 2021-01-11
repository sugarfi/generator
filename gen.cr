module Language
    class Generator
        CONS = [
            'k',
            'e',
            'b',
            'n',
            'v',
            'd'
        ]

        CONS_TRANS = {
            'q' => 'k',
            'g' => 'k',
            'x' => 'k',
            'c' => 'k',
            's' => 'e',
            'z' => 'e',
            'r' => 'e',
            't' => 'e',
            'j' => 'e',
            'p' => 'b',
            'y' => 'b',
            'm' => 'n',
            'f' => 'v',
            'w' => 'v',
            'l' => 'v'
        }

        VOWEL = [
            'u',
            'a',
            'o'
        ]

        VOWEL_TRANS = {
            'e' => 'a',
            'i' => 'y'
        }

        private def self.rank_c(c : Char)
            if CONS.includes? c
                2
            elsif CONS_TRANS.keys.includes? c
                1
            else
                0
            end
        end

        private def self.trans_c(c : Char)
            if CONS.includes? c
                c
            elsif CONS_TRANS.keys.includes? c
                CONS_TRANS[c]
            else
                'd'
            end
        end

        private def self.rank_v(v : Char)
            if VOWEL.includes? v
                2
            elsif VOWEL_TRANS.keys.includes? v
                1
            else
                0
            end
        end

        private def self.trans_v(v : Char)
            if VOWEL.includes? v
                v
            elsif VOWEL_TRANS.keys.includes? v
                VOWEL_TRANS[v]
            else
                'o'
            end
        end

        def self.generate(words : Array(String))
            len = words.map(&.size).min
            len -= 1 if len % 2 > 0
            len //= 2

            syllables = [] of String
            len.times do |i|
                parts = words.map do |x|
                    { x[i * 2], x[i * 2 + 1] }
                end.reverse
                c = 'd'
                v = 'o'
                cr = 0
                vr = 0
                parts.each do |part|
                    if (ncr = rank_c part[0]) >= cr
                        cr = ncr
                        c = trans_c part[0]
                    end
                    if (nvr = rank_v part[1]) >= vr
                        vr = nvr
                        v = trans_v part[1]
                    end
                end

                syllables << "#{c}#{v}"
            end

            syllables.join
        end
    end
end
