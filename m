Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A56DE29DFE
	for <xfs@oss.sgi.com>; Wed, 18 Dec 2013 12:16:11 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 39E90AC002
	for <xfs@oss.sgi.com>; Wed, 18 Dec 2013 10:16:11 -0800 (PST)
Received: from mail-oa0-f74.google.com (mail-oa0-f74.google.com
	[209.85.219.74]) by cuda.sgi.com with ESMTP id Paksgo8CjQR79YXD
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 18 Dec 2013 10:16:10 -0800 (PST)
Received: by mail-oa0-f74.google.com with SMTP id o6so2122oag.3
	for <xfs@oss.sgi.com>; Wed, 18 Dec 2013 10:16:09 -0800 (PST)
From: Junho Ryu <jayr@google.com>
Subject: [PATCH v3 08/12] xfstests: add executable permission to tests
Date: Wed, 18 Dec 2013 10:15:59 -0800
Message-Id: <1387390563-27064-8-git-send-email-jayr@google.com>
In-Reply-To: <1387390563-27064-1-git-send-email-jayr@google.com>
References: <1387390563-27064-1-git-send-email-jayr@google.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: tytso@mit.edu, hughd@google.com, branto@redhat.com, Junho Ryu <jayr@google.com>

From: Hugh Dickins <hughd@google.com>

add executable permission to generic/311, generic/314 and generic/315.
Just like other tests in the same directory.

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Junho Ryu <jayr@google.com>
---

v3: same as v1

v2: same as v1

 tests/generic/311 | 0
 tests/generic/315 | 0
 tests/generic/321 | 0
 tests/generic/322 | 0
 4 files changed, 0 insertions(+), 0 deletions(-)
 mode change 100644 => 100755 tests/generic/311
 mode change 100644 => 100755 tests/generic/315
 mode change 100644 => 100755 tests/generic/321
 mode change 100644 => 100755 tests/generic/322

diff --git a/tests/generic/311 b/tests/generic/311
old mode 100644
new mode 100755
diff --git a/tests/generic/315 b/tests/generic/315
old mode 100644
new mode 100755
diff --git a/tests/generic/321 b/tests/generic/321
old mode 100644
new mode 100755
diff --git a/tests/generic/322 b/tests/generic/322
old mode 100644
new mode 100755
-- 
1.8.5.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
