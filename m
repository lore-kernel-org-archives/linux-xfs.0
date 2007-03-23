Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 23 Mar 2007 01:37:34 -0700 (PDT)
Received: from mail.interline.it (mail.interline.it [195.182.241.4])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2N8bS6p018402
	for <xfs@oss.sgi.com>; Fri, 23 Mar 2007 01:37:31 -0700
Received: from localhost (localhost [127.0.0.1])
	by mail.interline.it (Postfix) with ESMTP id D864D103B
	for <xfs@oss.sgi.com>; Fri, 23 Mar 2007 09:28:23 +0100 (CET)
Received: from mail.interline.it ([127.0.0.1])
	by localhost (pin [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
	id 27574-05 for <xfs@oss.sgi.com>;
	Fri, 23 Mar 2007 09:28:17 +0100 (CET)
From: "Daniele P." <daniele@interline.it>
Subject: Re: xfsrepair memory consumption
Date: Fri, 23 Mar 2007 09:36:47 +0100
References: <200703210843.TAA08491@larry.melbourne.sgi.com> <200703211208.27665.daniele@interline.it> <20070321213611.GB1208@tuatara.stupidest.org>
In-Reply-To: <20070321213611.GB1208@tuatara.stupidest.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200703230936.47788.daniele@interline.it>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Wednesday 21 March 2007 22:36, Chris Wedgwood wrote:
> On Wed, Mar 21, 2007 at 12:08:27PM +0100, Daniele P. wrote:
> > Phase 6 still uses little more memory (killed!).
> > I will add more memory and will test later.
>
> Stupid question (Sorry, I didn't read the thread that carefully), is
> there any reason you can't just add swap-space and let it thrash a
> little?

Oh, it's less expensive (less typing) to add ram because it's a
virtual machine.
Finally using the 2.8.20-1 version requires 1 GB of memory vs 750 MB for
2.6.20-1.
Next time I will add more swap by default.

Regards,
Daniele P.
