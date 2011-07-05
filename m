Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p65B156v252464 for <xfs@oss.sgi.com>; Tue, 5 Jul 2011 06:01:05 -0500
Received: from firestarter.dermichi.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DFCF2E761DE
	for <xfs@oss.sgi.com>; Tue,  5 Jul 2011 04:01:04 -0700 (PDT)
Received: from firestarter.dermichi.com (firestarter.dermichi.com
	[78.41.115.230]) by cuda.sgi.com with ESMTP id KWKQTT7CpvQDwSso
	for <xfs@oss.sgi.com>; Tue, 05 Jul 2011 04:01:04 -0700 (PDT)
Message-ID: <4E12EEEE.5030106@dermichi.com>
Date: Tue, 05 Jul 2011 13:01:02 +0200
From: Michael Weissenbacher <mw@dermichi.com>
MIME-Version: 1.0
Subject: Re: xfs_bmap Cannot allocate memory
References: <4E129B00.4020709@dermichi.com>
	<20110705104959.GA20919@infradead.org>
In-Reply-To: <20110705104959.GA20919@infradead.org>
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

Hi Christoph!
> 
> What version of xfsprogs do you use?  xfsprogs 3.0.1 fixes a problem
> in the bmap command that looked pretty similar to what you see.
> 
> 
Sorry, i forgot to mention that in my original post:
# xfs_bmap -V
xfs_bmap version 3.1.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
