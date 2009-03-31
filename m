Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2VLrFo3029563 for <xfs@oss.sgi.com>; Tue, 31 Mar 2009 16:53:25 -0500
Received: from ten.citi.umich.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1FBF013E2FFF
	for <xfs@oss.sgi.com>; Tue, 31 Mar 2009 14:53:41 -0700 (PDT)
Received: from ten.citi.umich.edu (ten.citi.umich.edu [141.211.133.138]) by
	cuda.sgi.com with ESMTP id ikGaHRUjJJhdvfro for
	<xfs@oss.sgi.com>; Tue, 31 Mar 2009 14:53:41 -0700 (PDT)
From: "Josef 'Jeff' Sipek" <jsipek@eecs.umich.edu>
Subject: [PATCH 1/2] xfstests: make the mode consistent for all the test
	scripts
Date: Tue, 31 Mar 2009 17:50:33 -0400
Message-Id: <1238536234-26969-2-git-send-email-jsipek@eecs.umich.edu>
In-Reply-To: <1238536234-26969-1-git-send-email-jsipek@eecs.umich.edu>
References: <1238536234-26969-1-git-send-email-jsipek@eecs.umich.edu>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>, Josef 'Jeff' Sipek <jsipek@eecs.umich.edu>

From: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>

Signed-off-by: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@eecs.umich.edu>
---
 0 files changed, 0 insertions(+), 0 deletions(-)
 mode change 100644 => 100755 104
 mode change 100755 => 100644 112.out
 mode change 100644 => 100755 141
 mode change 100644 => 100755 164
 mode change 100644 => 100755 165
 mode change 100644 => 100755 166
 mode change 100644 => 100755 167
 mode change 100644 => 100755 170
 mode change 100644 => 100755 171
 mode change 100644 => 100755 172
 mode change 100644 => 100755 173
 mode change 100644 => 100755 174
 mode change 100644 => 100755 179
 mode change 100644 => 100755 180
 mode change 100644 => 100755 182
 mode change 100644 => 100755 183
 mode change 100644 => 100755 184
 mode change 100644 => 100755 185
 mode change 100644 => 100755 188
 mode change 100644 => 100755 189
 mode change 100644 => 100755 194
 mode change 100644 => 100755 195
 mode change 100644 => 100755 196
 mode change 100644 => 100755 197
 mode change 100644 => 100755 198
 mode change 100644 => 100755 199
 mode change 100644 => 100755 200
 mode change 100644 => 100755 201
 mode change 100644 => 100755 202
 mode change 100644 => 100755 203

diff --git a/104 b/104
old mode 100644
new mode 100755
diff --git a/112.out b/112.out
old mode 100755
new mode 100644
diff --git a/141 b/141
old mode 100644
new mode 100755
diff --git a/164 b/164
old mode 100644
new mode 100755
diff --git a/165 b/165
old mode 100644
new mode 100755
diff --git a/166 b/166
old mode 100644
new mode 100755
diff --git a/167 b/167
old mode 100644
new mode 100755
diff --git a/170 b/170
old mode 100644
new mode 100755
diff --git a/171 b/171
old mode 100644
new mode 100755
diff --git a/172 b/172
old mode 100644
new mode 100755
diff --git a/173 b/173
old mode 100644
new mode 100755
diff --git a/174 b/174
old mode 100644
new mode 100755
diff --git a/179 b/179
old mode 100644
new mode 100755
diff --git a/180 b/180
old mode 100644
new mode 100755
diff --git a/182 b/182
old mode 100644
new mode 100755
diff --git a/183 b/183
old mode 100644
new mode 100755
diff --git a/184 b/184
old mode 100644
new mode 100755
diff --git a/185 b/185
old mode 100644
new mode 100755
diff --git a/188 b/188
old mode 100644
new mode 100755
diff --git a/189 b/189
old mode 100644
new mode 100755
diff --git a/194 b/194
old mode 100644
new mode 100755
diff --git a/195 b/195
old mode 100644
new mode 100755
diff --git a/196 b/196
old mode 100644
new mode 100755
diff --git a/197 b/197
old mode 100644
new mode 100755
diff --git a/198 b/198
old mode 100644
new mode 100755
diff --git a/199 b/199
old mode 100644
new mode 100755
diff --git a/200 b/200
old mode 100644
new mode 100755
diff --git a/201 b/201
old mode 100644
new mode 100755
diff --git a/202 b/202
old mode 100644
new mode 100755
diff --git a/203 b/203
old mode 100644
new mode 100755
-- 
1.6.0.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
