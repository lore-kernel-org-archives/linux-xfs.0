Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9QB1sDU065928 for <xfs@oss.sgi.com>; Tue, 26 Oct 2010 06:01:56 -0500
Received: from server655-han.de-nserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 94FF7151FD1B
	for <xfs@oss.sgi.com>; Tue, 26 Oct 2010 04:18:43 -0700 (PDT)
Received: from server655-han.de-nserver.de (server655-han.de-nserver.de
	[85.158.177.45]) by cuda.sgi.com with ESMTP id CiL2STkKEV2pELF1
	for <xfs@oss.sgi.com>; Tue, 26 Oct 2010 04:18:43 -0700 (PDT)
Message-ID: <4CC6B56B.7020007@profihost.ag>
Date: Tue, 26 Oct 2010 13:03:07 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: Re: Pid: 8345, comm: rsync Not tainted 2.6.32.22intel #1
References: <4CC67450.9020602@profihost.ag>	<20101026092205.086c0d89@galadriel.home>	<4CC68249.7050409@profihost.ag>	<20101026094111.48670eb7@galadriel.home>	<4CC688FE.7010206@profihost.ag>
	<20101026130103.7cc43aec@harpe.intellique.com>
In-Reply-To: <20101026130103.7cc43aec@harpe.intellique.com>
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

Hi,

it is a 9650SE-8LPML with Firmware: FE9X 3.06.00.003.

So you mean i should upgrade to 4.x Firmware? Do i then have to do a =

filesystem repair? Or just wait if the error accours again?

Stefan

Am 26.10.2010 13:01, schrieb Emmanuel Florac:
> Le Tue, 26 Oct 2010 09:53:34 +0200
> Stefan Priebe - Profihost AG<s.priebe@profihost.ag>  =E9crivait:
>
>> No it is a Raid 5 (3Ware Controller).
>
> What model? Which firmware? If it's a 96x0 model, notice that 4.x.x
> firmwares added lots of performance enhancements and solved many
> problems.
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
