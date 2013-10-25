Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B37C97F3F
	for <xfs@oss.sgi.com>; Fri, 25 Oct 2013 09:43:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8ACC4304067
	for <xfs@oss.sgi.com>; Fri, 25 Oct 2013 07:43:02 -0700 (PDT)
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5]) by
	cuda.sgi.com with ESMTP id d0YgTjmCPJIFHw5l for
	<xfs@oss.sgi.com>; Fri, 25 Oct 2013 07:42:59 -0700 (PDT)
Date: Fri, 25 Oct 2013 16:42:55 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Questions about XFS
Message-ID: <20131025164255.46d2829c@harpe.intellique.com>
In-Reply-To: <CAD+1EGPG1G9Q8kwaSUjxVjvx73UByLb3G0rmUbgJr+zD-CnjEw@mail.gmail.com>
References: <CAD+1EGPG1G9Q8kwaSUjxVjvx73UByLb3G0rmUbgJr+zD-CnjEw@mail.gmail.com>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: harryxiyou <harryxiyou@gmail.com>
Cc: xfs@oss.sgi.com

Le Fri, 25 Oct 2013 22:28:10 +0800
harryxiyou <harryxiyou@gmail.com> =E9crivait:

> 1, How to install XFS on Linux OS, I should do like below, right?
>    a, Download latest Linux Kernel Source Codes.
>    b, Compile the Linux Kernel and select XFS feature when I do the
> configuration (make menuconfig).

No, XFS is supported by all Linux distributions out of the box. To use
XFS, you may eventually need to install the xfs-progs package.

 =

> 2, Does XFS support real-time feature after I install it on Linux
> Kernel? And how to use real-time feature on Linux Kernel.
> =


Yes. What do you want to do with realtime XFS?

-- =

------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
