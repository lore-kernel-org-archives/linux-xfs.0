Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q02A9XiM152238 for <xfs@oss.sgi.com>; Mon, 2 Jan 2012 04:09:33 -0600
Received: from smtp-tls.univ-nantes.fr (smtp-tls1.univ-nantes.fr
	[193.52.101.145]) by cuda.sgi.com with ESMTP id
	HL5Xr9Zfwj3w3pDH for <xfs@oss.sgi.com>;
	Mon, 02 Jan 2012 02:09:31 -0800 (PST)
Message-ID: <4F0181A2.5010505@univ-nantes.fr>
Date: Mon, 02 Jan 2012 11:06:26 +0100
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
	<4EF21DD2.3060004@univ-nantes.fr> <20111221222623.GF23662@dastard>
	<4EF2F702.4050902@univ-nantes.fr> <4EF30E5D.7060608@univ-nantes.fr>
In-Reply-To: <4EF30E5D.7060608@univ-nantes.fr>
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
To: Yann Dupont <Yann.Dupont@univ-nantes.fr>
Cc: stan@hardwarefreak.com, xfs@oss.sgi.com

Le 22/12/2011 12:02, Yann Dupont a =E9crit :
> Le 22/12/2011 10:23, Yann Dupont a =E9crit :
>>
>>> Can you run a block trace on both kernels (for say five minutes)
>>> when the load differential is showing up and provide that to us so
>>> we can see how the IO patterns are differing?
>
>
> here we go.
>

Hello, happy new year everybody ,

Did someone had time to examine the 2 blktrace ? (and, by chance, can =

see the root cause of the increased load ?)

One of my server is still running 3.1.6. In the coming days I'll see a =

very important load increase (today is still calm). Is there anything I =

can do to go further  ?

Thanks,




-- =

Yann Dupont - Service IRTS, DSI Universit=E9 de Nantes
Tel : 02.53.48.49.20 - Mail/Jabber : Yann.Dupont@univ-nantes.fr

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
