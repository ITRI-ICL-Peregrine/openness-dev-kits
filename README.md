```text
SPDX-License-Identifier: Apache-2.0
Copyright (c) 2019 Intel Corporation
```

Folk from https://github.com/open-ness/openness-experience-kits
For documentation please refer to https://github.com/open-ness/specs/blob/master/doc/getting-started/openness-experience-kits.md

## Trouble Shooting

### "source command not found in sh shell"

```shell
$ls -l `which sh`
```

```text
/bin/sh -> dash
```

```shell
sudo dpkg-reconfigure dash #Select "no" when you're asked
```

```shell
$ls -l `which sh`
```

```text
/bin/sh -> bash
```

Done
