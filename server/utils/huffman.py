import heapq
from collections import defaultdict, Counter


class Node:
    def __init__(self, char, freq):
        self.char = char
        self.freq = freq
        self.left = None
        self.right = None

    def __lt__(self, other):
        return self.freq < other.freq


def build_huffman_tree(text):
    char_freq = Counter(text)
    heap = [Node(char, freq) for char, freq in char_freq.items()]
    heapq.heapify(heap)

    while len(heap) > 1:
        left = heapq.heappop(heap)
        right = heapq.heappop(heap)
        merged = Node(None, left.freq + right.freq)
        merged.left = left
        merged.right = right
        heapq.heappush(heap, merged)

    return heap[0]


def build_huffman_codes(root, current_code="", codes=None):
    if codes is None:
        codes = {}

    if root is not None:
        if root.char is not None:
            codes[root.char] = current_code
        build_huffman_codes(root.left, current_code + "0", codes)
        build_huffman_codes(root.right, current_code + "1", codes)

    return codes


def huffman_encoding(text):
    root = build_huffman_tree(text)
    codes = build_huffman_codes(root)
    encoded_text = "".join(codes[char] for char in text)
    return encoded_text, root


def huffman_decoding(encoded_text, root):
    decoded_text = ""
    current_node = root

    for bit in encoded_text:
        if bit == "0":
            current_node = current_node.left
        else:
            current_node = current_node.right

        if current_node.char is not None:
            decoded_text += current_node.char
            current_node = root

    return decoded_text


# Example usage:
text = "/9j/4QAYRXhpZgAASUkqAAgAAAAAAAAAAAAAAP/sABFEdWNreQABAAQAAAAzAAD/4QMfaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wLwA8P3hwYWNrZXQgYmVnaW49Iu+7vyIgaWQ9Ilc1TTBNcENlaGlIenJlU3pOVGN6a2M5ZCI/PiA8eDp4bXBtZXRhIHhtbG5zOng9ImFkb2JlOm5zOm1ldGEvIiB4OnhtcHRrPSJBZG9iZSBYTVAgQ29yZSA1LjYtYzE0MCA3OS4xNjA0NTEsIDIwMTcvMDUvMDYtMDE6MDg6MjEgICAgICAgICI+IDxyZGY6UkRGIHhtbG5zOnJkZj0iaHR0cDovL3d3dy53My5vcmcvMTk5OS8wMi8yMi1yZGYtc3ludGF4LW5zIyI+IDxyZGY6RGVzY3JpcHRpb24gcmRmOmFib3V0PSIiIHhtbG5zOnhtcE1NPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvbW0vIiB4bWxuczpzdFJlZj0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL3NUeXBlL1Jlc291cmNlUmVmIyIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bXBNTTpEb2N1bWVudElEPSJ4bXAuZGlkOjQyQkQ0NkQ4NEJFMjExRTg5QzYwQjVFNUIwQ0E5RjAzIiB4bXBNTTpJbnN0YW5jZUlEPSJ4bXAuaWlkOjQyQkQ0NkQ3NEJFMjExRTg5QzYwQjVFNUIwQ0E5RjAzIiB4bXA6Q3JlYXRvclRvb2w9IkFkb2JlIFBob3Rvc2hvcCBDQyAyMDE4IE1hY2ludG9zaCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJGRDAxRTIyNTkwQjQyRUQ4RDA4Rjk1OUYzREREMUYwRiIgc3RSZWY6ZG9jdW1lbnRJRD0iRkQwMUUyMjU5MEI0MkVEOEQwOEY5NTlGM0RERDFGMEYiLz4gPC9yZGY6RGVzY3JpcHRpb24+IDwvcmRmOlJERj4gPC94OnhtcG1ldGE+IDw/eHBhY2tldCBlbmQ9InIiPz7/7gAhQWRvYmUAZMAAAAABAwAQAwMGCQAAFwcAACPUAAA4j//bAIQACAUFBQYFCAYGCAsH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"
encoded_text, huffman_tree = huffman_encoding(text)
decoded_text = huffman_decoding(encoded_text, huffman_tree)

# print("Original text:", text)
print("Encoded text:", encoded_text)
# print("Decoded text:", decoded_text)
