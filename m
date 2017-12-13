Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752924AbdLMAp0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Dec 2017 19:45:26 -0500
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH 2/9] README: document group fsgqa is required
Date: Tue, 12 Dec 2017 16:45:12 -0800
Message-Id: <20171213004519.29340-3-mcgrof@kernel.org>
In-Reply-To: <20171213004519.29340-1-mcgrof@kernel.org>
References: <20171213004519.29340-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@kernel.org>

The group fsgqa is also required.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 README | 1 +
 1 file changed, 1 insertion(+)

diff --git a/README b/README
index e05142be1a87..271d7df22b56 100644
--- a/README
+++ b/README
@@ -20,6 +20,7 @@ _______________________
 - run make
 - run make install
 - create fsgqa test user ("sudo useradd fsgqa")
+- create fsgqa group ("sudo groupadd fsgqa")
 - create fsgqa-381 test user ("sudo useradd fsgqa-381")
 	
 ______________________
-- 
2.15.0

