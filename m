Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8C7C77F94
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 14:12:22 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7483F304067
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 12:12:22 -0800 (PST)
Received: from mail-ie0-f201.google.com (mail-ie0-f201.google.com
	[209.85.223.201]) by cuda.sgi.com with ESMTP id
	dANcSJMz7AREz9Wd (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 10 Dec 2013 12:12:21 -0800 (PST)
Received: by mail-ie0-f201.google.com with SMTP id at1so1116117iec.0
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 12:12:21 -0800 (PST)
From: Junho Ryu <jayr@google.com>
Subject: [PATCH 09/10] xfstests: add executable permission to tests
Date: Tue, 10 Dec 2013 12:12:00 -0800
Message-Id: <1386706321-15795-10-git-send-email-jayr@google.com>
In-Reply-To: <1386706321-15795-1-git-send-email-jayr@google.com>
References: <1386706321-15795-1-git-send-email-jayr@google.com>
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
 tests/generic/311 | 0
 tests/generic/314 | 0
 tests/generic/315 | 0
 tests/generic/321 | 0
 tests/generic/322 | 0
 5 files changed, 0 insertions(+), 0 deletions(-)
 mode change 100644 => 100755 tests/generic/311
 mode change 100644 => 100755 tests/generic/314
 mode change 100644 => 100755 tests/generic/315
 mode change 100644 => 100755 tests/generic/321
 mode change 100644 => 100755 tests/generic/322

diff --git a/tests/generic/311 b/tests/generic/311
old mode 100644
new mode 100755
diff --git a/tests/generic/314 b/tests/generic/314
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
