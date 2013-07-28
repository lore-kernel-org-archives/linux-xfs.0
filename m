Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0FA2229DFC
	for <xfs@oss.sgi.com>; Sun, 28 Jul 2013 10:46:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D4B458F8037
	for <xfs@oss.sgi.com>; Sun, 28 Jul 2013 08:46:00 -0700 (PDT)
Received: from benjamin.baylink.com (rrcs-24-129-180-187.se.biz.rr.com
	[24.129.180.187]) by cuda.sgi.com with ESMTP id
	ABNB1DfLw3DmLipH for <xfs@oss.sgi.com>;
	Sun, 28 Jul 2013 08:45:59 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by benjamin.baylink.com (Postfix) with ESMTP id 76CEC1F00362
	for <xfs@oss.sgi.com>; Sun, 28 Jul 2013 11:45:58 -0400 (EDT)
Received: from benjamin.baylink.com ([127.0.0.1])
	by localhost (benjamin.baylink.com [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id 3dRAAb6J7AbK for <xfs@oss.sgi.com>;
	Sun, 28 Jul 2013 11:45:54 -0400 (EDT)
Received: from benjamin.baylink.com (benjamin.baylink.com [192.168.253.10])
	by benjamin.baylink.com (Postfix) with ESMTP id 4F7AF1F00206
	for <xfs@oss.sgi.com>; Sun, 28 Jul 2013 11:45:54 -0400 (EDT)
Date: Sun, 28 Jul 2013 11:45:54 -0400 (EDT)
From: Jay Ashworth <jra@baylink.com>
Message-ID: <22300590.2458.1375026354258.JavaMail.root@benjamin.baylink.com>
In-Reply-To: <51F4A77A.30502@hardwarefreak.com>
Subject: Re: Purpose of the XFS list -- was: A short digression on FOSS (Re:
	understanding speculative preallocation)
MIME-Version: 1.0
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
To: xfs@oss.sgi.com

----- Original Message -----
> From: "Stan Hoeppner" <stan@hardwarefreak.com>

> CentOS is a direct clone of RHEL. It uses the RHEL kernel. Thus XFS in
> the CentOS kernel is not generally supported on this mailing list.
> CentOS (and RHEL) userland XFS tools yes, kernel no. If there were some
> other custom distro kernel out there that was non mainline, it wouldn't
> get support here either.

Like, um, SuSE.  Which hasn't used "mainline kernels" in years, if ever.

What, exactly, Stan, *is* a mainline kernel?  kernel.org kernels?

No distribution worth its oats is using those; it isn't just CentOS.

> The reason "we" (and I'm not a Red Hat employee, nor a RHEL user)
> suggest to CentOS users that they become paying RHEL customers is
> obvious: they already use the software and are familiar and presumably
> comfortable with it and prefer it. If they pay they get Red Hat support
> for XFS in the kernel, along with anything else kernel related. If they
> want to continue to use a "no cost" OS and get support on this mailing
> list, they must have a distro with a mainline kernel. So the other
> obvious option is move to a distro that uses a mainline kernel. They
> may also be able to install a mainline kernel on CentOS, as someone
> suggested previously.

Or, they could use any other distro that isn't RHEL.

Or, well, SuSE, if your assertion is actually accurate, which I think it's
not, clearly.

> Nobody here is aiming guns at CentOS users heads. They have plenty of
> support options. It just so happens that using the stock CentOS (RHEL)
> kernel isn't one of them.

Ok.  Got it.  Then, since CentOS is the only realistic non-$1200/server/yr
distro available, I won't be using XFS anymore.

Note that you are pretty wildly violating the spirit of FOSS here.

Cheers,
-- jra
-- 
Jay R. Ashworth                  Baylink                       jra@baylink.com
Designer                     The Things I Think                       RFC 2100
Ashworth & Associates     http://baylink.pitas.com         2000 Land Rover DII
St Petersburg FL USA               #natog                      +1 727 647 1274

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
