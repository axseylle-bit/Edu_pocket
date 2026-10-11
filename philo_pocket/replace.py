import os
import re

directory = 'lib'

for root, _, files in os.walk(directory):
    for file in files:
        if file.endswith('.dart'):
            filepath = os.path.join(root, file)
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()

            new_content = content.replace('{Key? key}', '{super.key}')
            new_content = re.sub(r'\s*:\s*super\(key:\s*key\)', '', new_content)

            if new_content != content:
                with open(filepath, 'w', encoding='utf-8') as f:
                    f.write(new_content)
