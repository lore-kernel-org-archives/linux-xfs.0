Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A13F07F4E
	for <xfs@oss.sgi.com>; Tue, 22 Oct 2013 16:03:42 -0500 (CDT)
Received: from xmail.sgi.com (pv-excas2-dc21.corp.sgi.com [137.38.106.9])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8E5CA30408A
	for <xfs@oss.sgi.com>; Tue, 22 Oct 2013 14:03:39 -0700 (PDT)
Message-ID: <5266E829.1080704@sgi.com>
Date: Tue, 22 Oct 2013 16:03:37 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH V2] xfstests: Test xfs_fsr / swapext management of
	di_forkoff w/ selinux
References: <5260B62D.2010507@redhat.com> <52616072.6040808@sandeen.net>
In-Reply-To: <52616072.6040808@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Committed as test xfs/300.

--Rich

commit 5d88b638ff4ad68f5ecce96d5d4d3a85fc4a2a5c
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Fri Oct 18 16:23:14 2013 +0000

     xfstests: Test xfs_fsr / swapext management of di_forkoff w/ selinux

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
