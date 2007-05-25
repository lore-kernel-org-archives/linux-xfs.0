Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 25 May 2007 06:38:07 -0700 (PDT)
Received: from poczta.o2.pl (mx10.go2.pl [193.17.41.74])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4PDbxWt008855
	for <xfs@oss.sgi.com>; Fri, 25 May 2007 06:38:00 -0700
From: =?utf-8?q?=C5=81ukasz_Fibinger?= <lucke@o2.pl>
Reply-To: lucke@o2.pl
Subject: Re: RESVSP problems
Date: Fri, 25 May 2007 15:37:54 +0200
References: <200705241324.53283.lucke@o2.pl> <200705251224.23624.lucke@o2.pl> <20070525112441.GQ85884050@sgi.com>
In-Reply-To: <20070525112441.GQ85884050@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Message-Id: <200705251537.55567.lucke@o2.pl>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

On Friday 25 of May 2007, David Chinner wrote:
> On Fri, May 25, 2007 at 12:24:23PM +0200, Å?ukasz Fibinger wrote:
> > I see. If that's the case, would sharing your 2.6.21 XFS specific fixes
> > (you have them, right?) with me be any problem for you?
>
> The original XFS specific code was here:
>
> http://marc.info/?l=linux-fsdevel&m=117080251026985&w=2
>
> But if you want to patch your own kernel, I suggest that
> you use the latest generic version I posted here:
>
> http://marc.info/?l=linux-fsdevel&m=117426058311029&w=2
> http://marc.info/?l=linux-fsdevel&m=117426070111133&w=2
>

Seems to be working as expected. Thanks.

Cheers,

Luke
