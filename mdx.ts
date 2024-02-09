#!/usr/bin/env -S deno run --allow-read --allow-write

import { parse } from 'https://deno.land/std/flags/mod.ts'
import fs from 'node:fs/promises'
import {compile} from 'https://esm.sh/@mdx-js/mdx@3'

let source = 'mike-carifio.mdx'
let target = source + '.js'
fs.writeFile(target, String(await compile(await fs.readFile(source))), (err) => { if (err) console.error(err); })
  
