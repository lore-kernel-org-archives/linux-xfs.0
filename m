Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 15 May 2007 06:24:08 -0700 (PDT)
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4FDO1fB007752
	for <xfs@oss.sgi.com>; Tue, 15 May 2007 06:24:04 -0700
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l4FDNw43004993
	for <xfs@oss.sgi.com>; Tue, 15 May 2007 09:23:58 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l4FDNw4o269312
	for <xfs@oss.sgi.com>; Tue, 15 May 2007 07:23:58 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l4FDNvU0029955
	for <xfs@oss.sgi.com>; Tue, 15 May 2007 07:23:58 -0600
Date: Tue, 15 May 2007 18:53:53 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/5][TAKE2] fallocate() implementation on i86, x86_64 and powerpc
Message-ID: <20070515132353.GB12964@amitarora.in.ibm.com>
References: <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070514132926.GA30768@amitarora.in.ibm.com> <20070514142820.GA31468@amitarora.in.ibm.com> <20070514144524.GA31748@amitarora.in.ibm.com> <20070515094436.d441098f.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070515094436.d441098f.sfr@canb.auug.org.au>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

On Tue, May 15, 2007 at 09:44:36AM +1000, Stephen Rothwell wrote:
> On Mon, 14 May 2007 20:15:24 +0530 "Amit K. Arora" <aarora@linux.vnet.ibm.com> wrote:
> >
> > This patch implements sys_fallocate() and adds support on i386, x86_64
> > and powerpc platforms.
> 
> This patch no longer applies to Linus' tree - for a start there is no file
> arch/x86_64/kernel/functionlist any more.
> 
> Can you rebase it, please?

I will rebase it to 2.6.22-rc1 and repost the patches soon.
Thanks!

--
Regards,
Amit Arora
