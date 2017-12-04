Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:33937 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752441AbdLDVYo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Dec 2017 16:24:44 -0500
Message-Id: <20171204212120.984813771@linutronix.de>
Date: Mon, 04 Dec 2017 22:19:34 +0100
From: Thomas Gleixner <tglx@linutronix.de>
Subject: [patch V4 07/11] LICENSES: Add the BSD-3-clause "Clear" license
References: <20171204211927.673291734@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=LICENSES--Add-the-BSD-3-clause-Clear-license.patch
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kstewart@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, linux-xfs@vger.kernel.org, Charlemagne Lasse <charlemagnelasse@gmail.com>, Carmen Bianca Bakker <carmenbianca@fsfe.org>

Add the full text of the BSD 3-clause "Clear" License to the
kernel tree.  It was copied directly from:

  https://spdx.org/licenses/BSD-3-Clause-Clear.html

Add the required tags for reference and tooling.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Philippe Ombredanne <pombredanne@nexb.com>
Reviewed-by: Kate Stewart <kstewart@linuxfoundation.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 LICENSES/preferred/BSD-3-Clause-Clear |   41 ++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

--- /dev/null
+++ b/LICENSES/preferred/BSD-3-Clause-Clear
@@ -0,0 +1,41 @@
+Valid-License-Identifier: BSD-3-Clause-Clear
+SPDX-URL: https://spdx.org/licenses/BSD-3-Clause-Clear.html
+Usage-Guide:
+  To use the BSD 3-clause "Clear" License put the following SPDX
+  tag/value pair into a comment according to the placement guidelines in
+  the licensing rules documentation:
+    SPDX-License-Identifier: BSD-3-Clause-Clear
+License-Text:
+
+The Clear BSD License
+
+Copyright (c) [xxxx]-[xxxx] [Owner Organization]
+All rights reserved.
+
+Redistribution and use in source and binary forms, with or without
+modification, are permitted (subject to the limitations in the disclaimer
+below) provided that the following conditions are met:
+
+ * Redistributions of source code must retain the above copyright notice,
+   this list of conditions and the following disclaimer.
+
+ * Redistributions in binary form must reproduce the above copyright
+   notice, this list of conditions and the following disclaimer in the
+   documentation and/or other materials provided with the distribution.
+
+ * Neither the name of [Owner Organization] nor the names of its
+   contributors may be used to endorse or promote products derived from
+   this software without specific prior written permission.
+
+NO EXPRESS OR IMPLIED LICENSES TO ANY PARTY'S PATENT RIGHTS ARE GRANTED BY
+THIS LICENSE. THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
+CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT
+NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
+PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER
+OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
+EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
+PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
+OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
+WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
+OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
+ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


