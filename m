Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1RCrB3l058161 for <xfs@oss.sgi.com>; Mon, 27 Feb 2012 06:53:11 -0600
Received: from smtprelay05.ispgateway.de (smtprelay05.ispgateway.de
	[80.67.31.97]) by cuda.sgi.com with ESMTP id obcM93SGOLe3y6VW
	for <xfs@oss.sgi.com>; Mon, 27 Feb 2012 04:53:09 -0800 (PST)
Received: from [62.43.225.238] (helo=[192.168.30.191])
	by smtprelay05.ispgateway.de with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68) (envelope-from <richard.ems@cape-horn-eng.com>)
	id 1S204f-0007lE-P7
	for xfs@oss.sgi.com; Mon, 27 Feb 2012 13:53:05 +0100
Message-ID: <4F4B7CB1.50102@cape-horn-eng.com>
Date: Mon, 27 Feb 2012 13:53:05 +0100
From: Richard Ems <richard.ems@cape-horn-eng.com>
MIME-Version: 1.0
Subject: Re: XFS status update for January 2012
References: <20120225120216.GA21721@infradead.org>
	<4F4B5CB3.8090107@cape-horn-eng.com>
	<4F4B7408.8020706@waagmeester.co.za>
In-Reply-To: <4F4B7408.8020706@waagmeester.co.za>
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
To: xfs@oss.sgi.com

On 02/27/2012 01:16 PM, Coert Waagmeester wrote:

> Hello Richard,
> =

> Here I am running gentoo with kernel 3.2
> In the 2.6 era I always mounted my xfs file systems with the delaylog
> option, is this still necessary? Is delaylog now default?

Hi Coert,

I am running now 3.2.7 and the output of " grep xfs /proc/mounts " shows
delaylog as being in use. I didn't put this option in /etc/fstab, so I
think it must be default now.

But surely a developer can give a much better answer to your question.

Richard


-- =

Richard Ems       mail: Richard.Ems@Cape-Horn-Eng.com

Cape Horn Engineering S.L.
C/ Dr. J.J. D=F3mine 1, 5=BA piso
46011 Valencia
Tel : +34 96 3242923 / Fax 924
http://www.cape-horn-eng.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
