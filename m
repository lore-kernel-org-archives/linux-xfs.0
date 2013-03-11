Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 09C147F37
	for <xfs@oss.sgi.com>; Mon, 11 Mar 2013 11:15:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EB41B30406B
	for <xfs@oss.sgi.com>; Mon, 11 Mar 2013 09:15:34 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de
	[212.227.126.171]) by cuda.sgi.com with ESMTP id
	6sP15nateqCB4iv8 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 11 Mar 2013 09:15:30 -0700 (PDT)
From: Hans-Peter Jansen <hpj@urpla.net>
Subject: Re: Maximum file system size of XFS?
Date: Mon, 11 Mar 2013 17:15:08 +0100
Message-ID: <4238234.1XBMaocpAb@xrated>
In-Reply-To: <513DB9C2.3050408@hardwarefreak.com>
References: <20130309215121.0e614ef8@thinky>
	<513C3C43.7080104@hardwarefreak.com>
	<513DB9C2.3050408@hardwarefreak.com>
MIME-Version: 1.0
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
To: xfs@oss.sgi.com, stan@hardwarefreak.com
Cc: Eric Sandeen <sandeen@sandeen.net>, Pascal <pa5ca1@gmx.de>

Am Montag, 11. M=E4rz 2013, 06:02:26 schrieb Stan Hoeppner:
> On 3/10/2013 1:54 AM, Stan Hoeppner wrote:
> > So in summary, an Exabyte scale XFS is simply not practical today, and
> > won't be for at least another couple of decades, or more, if ever.  The
> > same holds true for some of the other filesystems you're going to be
> > writing about.  Some of the cluster and/or distributed filesystems
> > you're looking at could probably scale to Exabytes today.  That is, if
> > someone had the budget for half a million hard drives, host systems,
> > switches, etc, the facilities to house it all, and the budget for power
> > and cooling.  That's 834 racks for drives alone, just under 1/3rd of a
> > mile long if installed in a single row.
> =

> Jet lag due to time travel caused a math error above.  With today's 4TB
> drives it would require 2.25 million units for a raw 9EB capacity.
> That's 3,750 racks of 600 drives each.  These would stretch 1.42 miles,
> 7500 ft.

And I just acknowledged the building plans for our new datacenter, based on =

your former calculations. The question is, who carries the costs of the now =

needed 4 other floors of that building.. =


Are you well-insured, Stan?

Cheers,
Pete

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
