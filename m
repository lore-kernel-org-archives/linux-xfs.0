Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7792E7F6A
	for <xfs@oss.sgi.com>; Mon,  9 Dec 2013 10:39:42 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4FE97304032
	for <xfs@oss.sgi.com>; Mon,  9 Dec 2013 08:39:42 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 5nij3PXjH75KdHZc for <xfs@oss.sgi.com>;
	Mon, 09 Dec 2013 08:39:40 -0800 (PST)
Message-ID: <52A5F249.1060505@sandeen.net>
Date: Mon, 09 Dec 2013 10:39:37 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS...Windows?
References: <000001cef46c$ab687cc0$02397640$@mail.com>
In-Reply-To: <000001cef46c$ab687cc0$02397640$@mail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Yuji Saeki <yuji1@mail.com>, xfs@oss.sgi.com

On 12/8/13, 5:24 PM, Yuji Saeki wrote:
> Congratulations on your file system, it=92s quite nice. I=92ve
> benchmarked it myself, it=92s very impressive. I=92m curious though, is
> there are thought to a Windows driver? If someone ported the most
> current-stable version to Windows (free) under the same license =91GNU
> Lesser General Public License=92 with entire credit to XFS

XFS isn't under the LGPL, it's GPL, as is the rest of the kernel code,
and the license terms should be quite clear.

> would SGI
> be okay with that? A =91no-warranty implied=92 (etc) kind of protection
> of course. Quite a few devs that I work with enjoy the XFS filesystem
> and we dev in both Linux and Windows. We=92re very interested in making
> this happen with respect to the XFS project.

I'm not a lawyer, but it's not really an issue of opinion - it's a legal
matter.  If you can port XFS to Windows while maintaining the terms
of the license agreements on both ends, you're free to do so.

The technical difficulty of such a task is another matter as well.  :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
