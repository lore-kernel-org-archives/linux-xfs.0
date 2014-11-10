Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 942BA7F59
	for <xfs@oss.sgi.com>; Mon, 10 Nov 2014 03:08:24 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 40B80AC05B
	for <xfs@oss.sgi.com>; Mon, 10 Nov 2014 01:08:21 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 14RlfVWjrCZQY3D8 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 10 Nov 2014 01:08:19 -0800 (PST)
Date: Mon, 10 Nov 2014 10:08:16 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/12 v4] Moving i_dquot out of struct inode
Message-ID: <20141110090816.GC15948@quack.suse.cz>
References: <1415099993-18034-1-git-send-email-jack@suse.cz>
	<20141108132136.GA22574@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141108132136.GA22574@lst.de>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@lst.de>
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, Jan Kara <jack@suse.cz>, Jeff Mahoney <jeffm@suse.de>, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, Joel Becker <jlbec@evilplan.org>, linux-fsdevel@vger.kernel.org, tytso@mit.edu, linux-ext4@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On Sat 08-11-14 14:21:36, Christoph Hellwig wrote:
> Looks good,
> 
> Acked-by: Christoph Hellwig <hch@lst.de>
  Thanks for review. I'll add the series to my tree and push it in the next
merge window.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
