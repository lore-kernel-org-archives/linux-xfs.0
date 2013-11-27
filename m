Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 227067F57
	for <xfs@oss.sgi.com>; Tue, 26 Nov 2013 20:36:47 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8FDBCAC003
	for <xfs@oss.sgi.com>; Tue, 26 Nov 2013 18:36:46 -0800 (PST)
Received: from boogeyman.armory.com
	(adsl-76-230-21-225.dsl.pltn13.sbcglobal.net [76.230.21.225])
	by cuda.sgi.com with ESMTP id fotkCW5HEodeS2D9 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 26 Nov 2013 18:36:44 -0800 (PST)
Date: Tue, 26 Nov 2013 18:36:43 -0800
From: Phil White <cerise@armory.com>
Subject: Re: Problem with mkfs.xfs on a regular file
Message-ID: <20131127023643.GC13101@boogeyman>
References: <20131127023119.GB13101@boogeyman>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131127023119.GB13101@boogeyman>
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
To: xfs@oss.sgi.com

On Tue, Nov 26, 2013 at 06:31:19PM -0800, Phil White wrote:
> Gents:
> 
> I was making an image for a VM using everyone's favorite fs with a line
> that looked something like this:
> -------------
> dd if=/dev/zero of=~/image bs=1024 count=1048576 && ./mkfs/mkfs.xfs && mount -o loop ~/image /mnt/loop
> -------------

Obviously, I intended "mkfs.xfs -f /root/image".

Why is proofreading *AFTER* you send an email so much more effective?

-Phil

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
