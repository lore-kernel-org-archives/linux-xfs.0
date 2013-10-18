Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7DA957F3F
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 12:27:24 -0500 (CDT)
Message-ID: <52616F79.8000801@sgi.com>
Date: Fri, 18 Oct 2013 12:27:21 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: restrict platform_test_xfs_fd to regular files
References: <5254221E.1000503@redhat.com>
In-Reply-To: <5254221E.1000503@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

This has been committed.

Thanks
--Rich

commit fcd6fa7f6a29188a756ff8b071a152bc9d62baf4
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Tue Oct 8 15:17:50 2013 +0000

     xfsprogs: restrict platform_test_xfs_fd to regular files

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
