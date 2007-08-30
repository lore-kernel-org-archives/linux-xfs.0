Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 30 Aug 2007 16:10:56 -0700 (PDT)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7UNAq4p028440
	for <xfs@oss.sgi.com>; Thu, 30 Aug 2007 16:10:55 -0700
Subject: Re: About errors in XFS header files and xfsprogs
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <68c491a60708301539t2d386c88n907de44cf1ed743b@mail.gmail.com>
References: <46D6F066.5000009@op.pl> <20070830165556.GA13308@infradead.org>
	 <68c491a60708301539t2d386c88n907de44cf1ed743b@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Fri, 31 Aug 2007 09:12:05 +1000
Message-Id: <1188515525.24970.112.camel@edge.yarra.acx>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Martin =?ISO-8859-1?Q?Schr=F6der?= <martin@oneiros.de>
Cc: xfs@oss.sgi.com

On Fri, 2007-08-31 at 00:39 +0200, Martin Schröder wrote:
> 
> 
> 
> 
> 2007/8/30, Christoph Hellwig <hch@infradead.org>:
> > On Thu, Aug 30, 2007 at 06:29:26PM +0200, Bogdan wrote:
> > >                                The header files should not only be
> > > ISO-C-compatible, but even ANSI-C-compatible. This will allow
> anyone
> > > to use them.
> >
> > Sais who?  The GNU C extensions are very useful for programming, and
> > there is no reason to move to an inferior dialect.
> 
> Do you want to limit xfs to gcc/Linux? Other Unices may use other ccs.
> 

These headers compile just fine on IRIX, FreeBSD and MacOSX ... the
gcc-specific pieces are in platform dependent headers already.

cheers.

--
Nathan
