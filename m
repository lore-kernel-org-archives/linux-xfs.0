Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBLHxaXK048142 for <xfs@oss.sgi.com>; Wed, 21 Dec 2011 11:59:36 -0600
Received: from smtp-tls.univ-nantes.fr (smtp-tls1.univ-nantes.fr
	[193.52.101.145]) by cuda.sgi.com with ESMTP id
	o5mbnqsurXXUkTu7 for <xfs@oss.sgi.com>;
	Wed, 21 Dec 2011 09:59:34 -0800 (PST)
Message-ID: <4EF21DD2.3060004@univ-nantes.fr>
Date: Wed, 21 Dec 2011 18:56:34 +0100
From: Yann Dupont <Yann.Dupont@univ-nantes.fr>
MIME-Version: 1.0
Subject: Re: Bad performance with XFS + 2.6.38 / 2.6.39
References: <CACaf2aYZ=k=x8sPFJs4f-4vQxs+qNyoO1EUi8X=iBjWjRhy99Q@mail.gmail.com>
	<20111211233929.GI14273@dastard>
	<CACaf2aYTsxOBXEJEbQu7gwAminBc3R2usDHvypJW0AqOfnz0Pg@mail.gmail.com>
	<20111212010053.GM14273@dastard>
	<CACaf2ab-YjXAFm767MmRU5iuOmvkqQW3ZTfQewD5SGvF-opgYQ@mail.gmail.com>
	<4EF1A224.2070508@univ-nantes.fr>
	<4EF1F6DD.8020603@hardwarefreak.com>
In-Reply-To: <4EF1F6DD.8020603@hardwarefreak.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: stan@hardwarefreak.com
Cc: xfs@oss.sgi.com

Le 21/12/2011 16:10, Stan Hoeppner a =E9crit :


> 1.  What mailbox format are you using?  Is this a constant or variable?

Maildir++

> 2.  Is the Dovecot rev and config the same everywhere, before/after?
Yes
> 3.  Are Dovecot instances using NFS to access the XFS volumes?
NO. direct LVM volumes from SAN
> 4.  Is this a  Dovecot 2.x cluster with director and NFS storage?
>
NO. This is dovecot plain & simple.

When I go back to older kernels, the load go down. With newer kernel, =

all is working well too, but load (as reported by uptime) is higher.

Thanks,

-- =

Yann Dupont - Service IRTS, DSI Universit=E9 de Nantes
Tel : 02.53.48.49.20 - Mail/Jabber : Yann.Dupont@univ-nantes.fr

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
