Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 19 Apr 2008 08:41:50 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3JFfQwo022213
	for <xfs@oss.sgi.com>; Sat, 19 Apr 2008 08:41:29 -0700
Received: from fg-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5EA8FA5B1EA
	for <xfs@oss.sgi.com>; Sat, 19 Apr 2008 08:42:06 -0700 (PDT)
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.154]) by cuda.sgi.com with ESMTP id A8oIrZNG4E8ctQDV for <xfs@oss.sgi.com>; Sat, 19 Apr 2008 08:42:06 -0700 (PDT)
Received: by fg-out-1718.google.com with SMTP id e12so866128fga.8
        for <xfs@oss.sgi.com>; Sat, 19 Apr 2008 08:42:05 -0700 (PDT)
Message-ID: <6101e8c40804190842n315bd61ft5ae0cffd456a8519@mail.gmail.com>
Date: Sat, 19 Apr 2008 17:42:05 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
Subject: Re: x86: 4kstacks default
In-Reply-To: <20080419151911.GB1595@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804181737.m3IHbabI010051@hera.kernel.org>
	 <20080418142934.38ce6bf4.akpm@linux-foundation.org>
	 <20080419142329.GA5339@elte.hu>
	 <6101e8c40804190735g17f1e0bj25c2bc0e2a6eac26@mail.gmail.com>
	 <20080419151911.GB1595@cs181133002.pp.htv.fi>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Adrian Bunk <bunk@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Arjan van de Ven <arjan@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@infradead.org>, David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

I dont know, thet this problem presentiert in 2.6.25, but im older
kernels yes (2.6.22> or 2.6.23>).

On 4/19/08, Adrian Bunk <bunk@kernel.org> wrote:
> On Sat, Apr 19, 2008 at 04:35:31PM +0200, Oliver Pinter wrote:
> >...
> > with the older kernel is typical: xfs+nfs+4k stack(+lvm)
>
> Does anyone still experience problems with 2.6.25?
>
> We all know that there once were problems, but if there are any left
> they should be reported and fixed.
>
> > Thanks,
> > Oliver
>
> cu
> Adrian
>
> --
>
>        "Is there not promise of rain?" Ling Tan asked suddenly out
>         of the darkness. There had been need of rain for many days.
>        "Only a promise," Lao Er said.
>                                        Pearl S. Buck - Dragon Seed
>
>


-- 
Thanks,
Oliver
