Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752938AbdLMAp2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Dec 2017 19:45:28 -0500
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH 3/9] generic/group: add 304 to dedupe group
Date: Tue, 12 Dec 2017 16:45:13 -0800
Message-Id: <20171213004519.29340-4-mcgrof@kernel.org>
In-Reply-To: <20171213004519.29340-1-mcgrof@kernel.org>
References: <20171213004519.29340-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@kernel.org>

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 tests/generic/group | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/generic/group b/tests/generic/group
index 6c3bb03a9973..4e2fb0f720ba 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -306,7 +306,7 @@
 301 auto quick clone
 302 auto quick clone
 303 auto quick clone
-304 auto quick clone
+304 auto quick clone dedupe
 305 auto quick clone
 306 auto quick rw
 307 auto quick acl
-- 
2.15.0

