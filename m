Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA3Lhsxd109547 for <xfs@oss.sgi.com>; Wed, 3 Nov 2010 16:43:55 -0500
Received: from mail.SerNet.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3D9A01C120FA
	for <xfs@oss.sgi.com>; Wed,  3 Nov 2010 14:45:16 -0700 (PDT)
Received: from mail.SerNet.de (mail1.SerNet.de [193.175.80.2]) by cuda.sgi.com
	with ESMTP id 4QscaOTudIb8bvHF for <xfs@oss.sgi.com>;
	Wed, 03 Nov 2010 14:45:16 -0700 (PDT)
Date: Wed, 3 Nov 2010 22:44:47 +0100
From: =?iso-8859-1?Q?Bj=F6rn?= JACKE <bj@sernet.de>
Subject: Re: Linux and DMAPI
References: <AANLkTim5FExj9GFQf9v1rzRmxqtNrdw_UR5VPUs4bPMq@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTim5FExj9GFQf9v1rzRmxqtNrdw_UR5VPUs4bPMq@mail.gmail.com>
Message-Id: <E1PDl8r-000N7I-Hb@intern.SerNet.DE>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Diego Woitasen <diego@woitasen.com.ar>
Cc: xfs@oss.sgi.com

On 2010-09-18 at 21:08 -0300 Diego Woitasen sent off:
> Hi,
>  I'm looking for software that supports DMAPI on Linux. I haven't
> found anything on the web. I need to implement HSM for a mail server,
> to store old messages in a secondary storage.
> =

>  Are there something implemented? Open source or propietary one? I
> prefer open source obviously...

unmaintained since years but might be interesting for you:
http://sourceforge.net/projects/openhsm/

The only Linux distri I know that contains XFS with DMAPI support is
SLES 8/9/10 (not sure about 11).

Bj=F6rn
-- =

SerNet GmbH, Bahnhofsallee 1b, 37081 G=F6ttingen
phone: +49-551-370000-0, fax: +49-551-370000-9
AG G=F6ttingen, HRB 2816, GF: Dr. Johannes Loxen

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
