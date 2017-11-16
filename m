Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:47755 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934475AbdKPTNy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Nov 2017 14:13:54 -0500
Message-Id: <20171116184358.946786382@linutronix.de>
Date: Thu, 16 Nov 2017 19:33:14 +0100
From: Thomas Gleixner <tglx@linutronix.de>
Subject: [patch V2 08/11] LICENSES: Add the MIT license
References: <20171116183306.103584007@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=LICENSES_Add_the_MIT_license.patch
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kate@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, linux-xfs@vger.kernel.org, Charlemagne Lasse <charlemagnelasse@gmail.com>, Carmen Bianca Bakker <carmenbianca@fsfe.org>, Kate Stewart <kstewart@linuxfoundation.org>

Add the full text of the MIT license to the kernel tree.  It was copied
directly from:

  https://spdx.org/licenses/MIT.html#licenseText

Add the required tags for reference and tooling.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Greg KH <gregkh@linuxfoundation.org>
Reviewed-by: Kate Stewart <kstewart@linuxfoundation.org>
Reviewed-by: Philippe Ombredanne <pombredanne@nexb.com>

---
 LICENSES/preferred/MIT |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)
 create mode 100644 LICENSES/MIT

--- /dev/null
+++ b/LICENSES/preferred/MIT
@@ -0,0 +1,30 @@
+Valid-License-Identifier: MIT
+SPDX-URL: https://spdx.org/licenses/MIT.html
+Usage-Guide:
+  To use the MIT License put the following SPDX tag/value pair into a
+  comment according to the placement guidelines in the licensing rules
+  documentation:
+    SPDX-License-Identifier: MIT
+License-Text:
+
+MIT License
+
+Copyright (c) <year> <copyright holders>
+
+Permission is hereby granted, free of charge, to any person obtaining a
+copy of this software and associated documentation files (the "Software"),
+to deal in the Software without restriction, including without limitation
+the rights to use, copy, modify, merge, publish, distribute, sublicense,
+and/or sell copies of the Software, and to permit persons to whom the
+Software is furnished to do so, subject to the following conditions:
+
+The above copyright notice and this permission notice shall be included in
+all copies or substantial portions of the Software.
+
+THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+DEALINGS IN THE SOFTWARE.


