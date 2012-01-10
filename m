Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0AKwwtT096382 for <xfs@oss.sgi.com>; Tue, 10 Jan 2012 14:58:59 -0600
Received: from mail.ud10.udmedia.de (ud10.udmedia.de [194.117.254.50]) by
	cuda.sgi.com with ESMTP id eRm83PCEqWg8xqPY for
	<xfs@oss.sgi.com>; Tue, 10 Jan 2012 12:58:56 -0800 (PST)
Date: Tue, 10 Jan 2012 21:58:54 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: Empty dir can't be removed ... because it's not empty?
Message-ID: <20120110205854.GA13261@x4>
References: <201201102126.35268.rafagriman@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201201102126.35268.rafagriman@gmail.com>
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
To: Rafa =?iso-8859-1?Q?Grim=E1n?= <rafagriman@gmail.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 2012.01.10 at 21:26 +0100, Rafa Grim=E1n wrote:
> Hi all :)
> =

> My /home is on an XFS partition all to it's own. The other day the lights=
 went =

> out and when I rebooted, there's an empty directory that can't be erased.=
 This =

> directory is a subdirectory in ~/.kde4/
> =

> The funny thing about this is that I can rename the directory, but I can'=
t =

> delete it:
> =

> Any idea of what's going on?
> Any tool I can use to understand what's happening?

Try to run xfs_repair on that partition.

-- =

Markus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
