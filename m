Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 74F377F78
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 18:38:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F176DAC002
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 16:38:51 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	KUc514kLZL35O5Lf for <xfs@oss.sgi.com>;
	Fri, 02 May 2014 16:38:49 -0700 (PDT)
Date: Sat, 3 May 2014 09:38:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS filesystem claims to be mounted after a disconnect
Message-ID: <20140502233823.GF26353@dastard>
References: <5363A1D8.2020402@gmail.com> <5363B4C9.4000900@sandeen.net>
	<5363CB5E.3090008@gmail.com> <5363CD70.3000006@sandeen.net>
	<5363DBD7.4060002@gmail.com> <5363E65C.6010006@sandeen.net>
	<5363ECE8.6030706@gmail.com> <5363EEF4.7020200@sandeen.net>
	<5363F22E.2060404@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5363F22E.2060404@gmail.com>
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
To: Martin Papik <mp6058@gmail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Fri, May 02, 2014 at 10:29:50PM +0300, Martin Papik wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA512
> 
> 
> > We have a lot of docs at 
> > http://xfs.org/index.php/XFS_Papers_and_Documentation in 
> > publican/xml format, but Dave has been making noises about 
> > converting that to asciidoc.  In any case, the goal is 
> > documentation which is readily available, version-controlled, for 
> > which patches may be submitted...
> 
> Unless this documentation is part of the installable package, its
> utility is limited. My expectation was for the manual pages to be the
> reference. There could be a snippet in each man page saying "for more
> information go to http://....", which would help locate this
> additional documentation. :-)

Eventually it will become exactly that - an installable XFS
documentation package that ends up in /usr/share/doc/xfs.  Other
parts of it will end up as the source for the wiki pages e.g.  the
FAQ. As I do stuff, it ends up here:

http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/xfs-documentation.git

But right now it's time and resources that limit the conversion and
development of that repository, so don't hold your breathe too long
waiting for it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
