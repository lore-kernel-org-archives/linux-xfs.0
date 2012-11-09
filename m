Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA9DcxZA112021 for <xfs@oss.sgi.com>; Fri, 9 Nov 2012 07:38:59 -0600
Received: from gulag1.americas.sgi.com (gulag1.americas.sgi.com
	[128.162.236.41])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 967D7304075
	for <xfs@oss.sgi.com>; Fri,  9 Nov 2012 05:40:56 -0800 (PST)
Message-Id: <20121109132358.256359544@sgi.com>
Date: Fri, 09 Nov 2012 07:23:58 -0600
From: rjohnston@sgi.com
Subject: [PATCH 0/3] xfstests: remove unused code and resolve warnings
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

This patchset:
   1. Removes the unsupported sgi and CRAY conditionals
   2. Removes the unused conditional NO_XFS
   3. Resolves compiler/configure warnings 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
