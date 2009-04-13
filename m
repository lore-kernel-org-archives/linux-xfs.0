Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3DLmvt3133886 for <xfs@oss.sgi.com>; Mon, 13 Apr 2009 16:49:07 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 446CB141AB2F
	for <xfs@oss.sgi.com>; Mon, 13 Apr 2009 14:50:19 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id LZxbzOTlFI3JTD3O for
	<xfs@oss.sgi.com>; Mon, 13 Apr 2009 14:50:19 -0700 (PDT)
Message-ID: <49E3B321.3060605@sandeen.net>
Date: Mon, 13 Apr 2009 16:48:17 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH]fix fbno in  xfs_dir2_node_addname_int
References: <47E5A982.8010002@gmail.com>
In-Reply-To: <47E5A982.8010002@gmail.com>
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
To: Kevin Xu <cgxu.gg@gmail.com>
Cc: xfs@oss.sgi.com

Kevin Xu wrote:
> if we didn't find a freespace block for our new entry  in the current 
> freeindex block, 
> return to the first freeindex block and continue to check.
> 

Kevin, you sent this and another patch a while ago, and we had asked for
more information in the changelogs, a Signed-off-by: line, and a
testcase if at all possible.

Any chance that you can provide these things?

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
