Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 52BC77F82
	for <xfs@oss.sgi.com>; Sun, 10 Nov 2013 14:34:29 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 419B3304043
	for <xfs@oss.sgi.com>; Sun, 10 Nov 2013 12:34:29 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Oea3qMU7Eh940d24 for <xfs@oss.sgi.com>;
	Sun, 10 Nov 2013 12:34:27 -0800 (PST)
Date: Mon, 11 Nov 2013 07:34:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfstest failures
Message-ID: <20131110203423.GP6188@dastard>
References: <20131106105451.GA31283@infradead.org>
	<20131106161825.GU1935@sgi.com> <527A887F.2030807@sandeen.net>
	<20131107081710.GC25157@infradead.org>
	<527B948C.9060905@sandeen.net>
	<20131107132739.GA16608@infradead.org>
	<527B99C3.6090903@sandeen.net>
	<20131107134848.GA1163@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131107134848.GA1163@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Ben Myers <bpm@sgi.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Thu, Nov 07, 2013 at 05:48:48AM -0800, Christoph Hellwig wrote:
> On Thu, Nov 07, 2013 at 07:46:43AM -0600, Eric Sandeen wrote:
> > Would an expected failure be only for tests which are known to be
> > not-fixed anywhere?
> 
> 
> Exactly.  If you want to be fancy we could allow a drop-in file to
> override it if you want something for RHEL testing or similar

Yup, that's exactly what the expunged test files are for. :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
