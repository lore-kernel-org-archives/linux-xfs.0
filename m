Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 29 Nov 2007 23:54:36 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAU7sTFU032616
	for <linux-xfs@oss.sgi.com>; Thu, 29 Nov 2007 23:54:33 -0800
Date: Fri, 30 Nov 2007 18:54:31 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS performance problems on Linux x86_64
Message-ID: <20071130075431.GN119954183@sgi.com>
References: <474C8A05.3020604@e-626.net> <20071127220536.GL119954183@sgi.com> <fii8bm$6h5$1@ger.gmane.org> <20071130045808.GK119954183@sgi.com> <474FB90C.4060905@tsabi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <474FB90C.4060905@tsabi.hu>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: =?iso-8859-1?B?VMOzdGg=?= Csaba <tsabi@tsabi.hu>
Cc: David Chinner <dgc@sgi.com>, Bernd Schubert <bernd-schubert@gmx.de>, linux-xfs@oss.sgi.com

On Fri, Nov 30, 2007 at 08:17:32AM +0100, Tóth Csaba wrote:
> Hello list,
> 
> I tried this parameters, and got this results with bonnie++. As i think
> there isnt any speedup with this parameteres, or i am doing something wrong?

The latter. 

Try creating more than 16 files in your test. Maybe 160,000 instead?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
