Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6BB967CBF
	for <xfs@oss.sgi.com>; Tue, 27 Aug 2013 12:56:18 -0500 (CDT)
Message-ID: <521CE87C.1050906@sgi.com>
Date: Tue, 27 Aug 2013 12:57:16 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_repair: zero out unused parts of superblocks
References: <520C3C60.3090500@redhat.com>
In-Reply-To: <520C3C60.3090500@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Michael Maier <m1278468@allmail.net>, xfs-oss <xfs@oss.sgi.com>

Thanks for the patch Eric,it has been committed.

commit cbd7508db4c9597889ad98d5f027542002e0e57c
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Thu Aug 15 02:26:40 2013 +0000

     xfs_repair: zero out unused parts of superblocks


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
