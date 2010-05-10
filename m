Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4AKKFoJ029003 for <xfs@oss.sgi.com>; Mon, 10 May 2010 15:20:15 -0500
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9B98A33121E
	for <xfs@oss.sgi.com>; Mon, 10 May 2010 13:22:25 -0700 (PDT)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id DXzKBMoFfWrAMRcB for
	<xfs@oss.sgi.com>; Mon, 10 May 2010 13:22:25 -0700 (PDT)
Date: Mon, 10 May 2010 22:22:11 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: bad primary superblock - bad magic number !!!
Message-ID: <20100510222211.3e73cdeb@galadriel.home>
In-Reply-To: <978493.86662.qm@web112902.mail.gq1.yahoo.com>
References: <28512276.post@talk.nabble.com> <4BE82955.2080009@sandeen.net>
	<978493.86662.qm@web112902.mail.gq1.yahoo.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Leo Davis <leo1783@yahoo.com>
Cc: xfs@oss.sgi.com

Le Mon, 10 May 2010 11:11:45 -0700 (PDT) vous =E9criviez:

> I agree. I destroy and re-create raid and everything would show up
> GOOD, only for it to break again. So was wondering whether those
> traces would point to anything.... my prime suspect is hard drives,
> but those xfs msgs confused me. =


Check the hard drives separately with the maker utility (Seatools,
etc). One of them at the very least must be seriously ill.

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
