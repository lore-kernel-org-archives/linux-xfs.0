Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB3Neg3q067675 for <xfs@oss.sgi.com>; Mon, 3 Dec 2012 17:40:42 -0600
Message-Id: <20121203144208.143464631@sgi.com>
Date: Mon, 03 Dec 2012 17:42:08 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [3.0-stable PATCH 00/36] Proposed 3.0-stable bug patches
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
To: stable@vger.kernel.org
Cc: xfs@oss.sgi.com

Here a collection of bug fixes for 3.0-stable. Many of these patches
were also selected by Dave Chinner as possible 3.0-stable patches:
	http://oss.sgi.com/archives/xfs/2012-08/msg00255.html

I chose only bug fixes and kept the changes to a minimum.

Patch 21/22 are required for the bug fix in patch 23 but they are
important changes in their own right.

--Mark

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
