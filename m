Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAAC75Z8080550 for <xfs@oss.sgi.com>; Thu, 10 Nov 2011 06:07:05 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CFA662338D1
	for <xfs@oss.sgi.com>; Thu, 10 Nov 2011 04:07:03 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ArkwlZO6ZVvYcoWO for
	<xfs@oss.sgi.com>; Thu, 10 Nov 2011 04:07:03 -0800 (PST)
Date: Thu, 10 Nov 2011 10:05:41 -0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 0/2] Set lost+found inode as used after its allocation
Message-ID: <20111110120541.GC21214@andromeda.usersys.redhat.com>
References: <1320857647-25511-1-git-send-email-cmaiolino@redhat.com>
	<20111110111133.GA6525@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111110111133.GA6525@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

> I'd love to see followups to use the the get_inode_offset helper more
> often, and to add a testcase for the bug if possible.

Hi Chris, I added the xfstests test case creation to my todo list, 
I should have this implemented soon.

-- 
--Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
