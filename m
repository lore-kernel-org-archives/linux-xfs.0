Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Aug 2008 18:19:18 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m7T1JCXW010789
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2008 18:19:13 -0700
Message-ID: <48B74EDB.7060407@sgi.com>
Date: Fri, 29 Aug 2008 11:20:27 +1000
From: Peter Leckie <pleckie@sgi.com>
MIME-Version: 1.0
Subject: Re: [2.6.27-rc4] XFS i_lock vs i_iolock...
References: <6278d2220808221412x28f4ac5dl508884c8030b364a@mail.gmail.com> <20080825010213.GO5706@disturbed> <48B21507.9050708@sgi.com> <20080825035542.GR5706@disturbed> <1219647573.20732.28.camel@twins> <20080825215532.GB28188@lst.de> <20080826024547.GX5706@disturbed> <20080826193508.GA17542@infradead.org>
In-Reply-To: <20080826193508.GA17542@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, Peter Zijlstra <peterz@infradead.org>, Lachlan McIlroy <lachlan@sgi.com>, Daniel J Blueman <daniel.blueman@gmail.com>, Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Christoph Hellwig wrote:
> Looks good.  We probably don't need the #ifdef DEBUG as ASSERT is
> debug-only anyway.
Hey Dave did you want to update the patch?
