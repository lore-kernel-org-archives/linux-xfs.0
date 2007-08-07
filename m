Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Aug 2007 13:19:43 -0700 (PDT)
Received: from an-out-0708.google.com (an-out-0708.google.com [209.85.132.251])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l77KJabm023283
	for <xfs@oss.sgi.com>; Tue, 7 Aug 2007 13:19:39 -0700
Received: by an-out-0708.google.com with SMTP id c38so404798ana
        for <xfs@oss.sgi.com>; Tue, 07 Aug 2007 13:19:41 -0700 (PDT)
Message-ID: <9a8748490708071251l72d1e564u3f0d3bd5b6e4110d@mail.gmail.com>
Date: Tue, 7 Aug 2007 21:51:40 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: [PATCH][RESEND] fix a potential NULL pointer deref in XFS on failed mount.
In-Reply-To: <20070806005214.GK31489@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200708042030.21375.jesper.juhl@gmail.com>
	 <20070806005214.GK31489@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, xfs-masters@oss.sgi.com

On 06/08/07, David Chinner <dgc@sgi.com> wrote:
> On Sat, Aug 04, 2007 at 08:30:21PM +0200, Jesper Juhl wrote:
> > Back in 2006 (2006-10-31 to be specific, reposted on 2006-11-16), I
> > submitted a patch to fix a potential NULL pointer deref in XFS on
> > failed mount.
>
> Already checked into xfs-dev tree. Will go to next mainline merge.
>
> http://oss.sgi.com/archives/xfs/2007-08/msg00030.html
>

Ok. Thanks a lot for the feedback David.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
