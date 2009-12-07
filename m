Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nB7MFKcU076504 for <xfs@oss.sgi.com>; Mon, 7 Dec 2009 16:15:21 -0600
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 42B70DD92CB
	for <xfs@oss.sgi.com>; Mon,  7 Dec 2009 14:15:53 -0800 (PST)
Received: from postoffice2.aconex.com (mail.aconex.com [203.89.202.182]) by
	cuda.sgi.com with ESMTP id BpXYrocX6Lw0KvTw for
	<xfs@oss.sgi.com>; Mon, 07 Dec 2009 14:15:53 -0800 (PST)
Date: Tue, 8 Dec 2009 09:15:44 +1100 (EST)
From: Nathan Scott <nscott@aconex.com>
Message-ID: <2111932765.978961260224144834.JavaMail.root@mail-au.aconex.com>
In-Reply-To: <20091204161426.GA21499@infradead.org>
Subject: Re: User Space Releases
MIME-Version: 1.0
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
Cc: Alex Elder <aelder@sgi.com>, xfs@oss.sgi.com


----- "Christoph Hellwig" <hch@infradead.org> wrote:

> So I think we're almost reading to get xfsprogs 3.1.0 and xfsdump
> 3.0.4
> out of the door.
> 
> As far as I'm concerned this is the todo list:
> 
> xfsprogs:
>  - get my pending repair btree checking patches reviewed and in
>  - update the changelog and possibly any other documentation
>  - update the Debian packaging

I've double-checked the deb packaging side of things, all good.
Could someone review following patch which does mild cleanup?

> xfsdump:
>  - get my configure defaults patch (just posted) in
>  - update the changelog and possibly any other documentation
>  - update the Debian packaging, possibly including the new source
>    generation using the hardlinked package directory.
> 
> Nathan, what's the time frame to get the Debian release bits done?

Will look into getting the deb packaging converted over during
the next day or two at most.

cheers.

-- 
Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
