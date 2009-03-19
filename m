Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2J9R6wL054905 for <xfs@oss.sgi.com>; Thu, 19 Mar 2009 04:27:26 -0500
Received: from mo-p00-ob.rzone.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E39861C54009
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2009 02:26:45 -0700 (PDT)
Received: from mo-p00-ob.rzone.de (mo-p00-ob.rzone.de [81.169.146.161]) by
	cuda.sgi.com with ESMTP id RPm1FoJoZF6yiOT3 for
	<xfs@oss.sgi.com>; Thu, 19 Mar 2009 02:26:45 -0700 (PDT)
Message-ID: <49C20F8E.3000504@liga01.de>
Date: Thu, 19 Mar 2009 10:25:34 +0100
From: Steffen Knauf <Steffen.Knauf@liga01.de>
MIME-Version: 1.0
Subject: Re: Lost files + indentical Foldernames on XFS Partition
References: <49BFDC6E.6050607@liga01.de> <49BFDDC5.9060500@sandeen.net>
	<49C029AF.5070205@liga01.de>
	<5948362D99F6F145B37A7D45B5DDA4481042DDA609@VMBX103.ihostexchange.net>
	<49C0B41C.2060506@liga01.de> <49C0FE64.3040203@sandeen.net>
In-Reply-To: <49C0FE64.3040203@sandeen.net>
Reply-To: Steffen.Knauf@liga01.de
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Sebastian Brings <sbrings@silexmedia.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>


>> Yes, but i mounted the partition only a short time parallel (we only =

>> read from this partition). At the moment, the mounted Filesystem is only =

>> mounted on one machine.
>>
>> Steffen
>>
>>     =

>
> oh... well in that case, do an xfs_repair before anything else.
>
> -Eric
>
>   =

I unmount the partition, but if i try to use xfs_repair, i get the =

following error:

xfs_repair: /dev/sdc3 contains a mounted and writable filesystem

fatal error -- couldn't initialize XFS library


greets

Steffen

-- =


 =


Steffen Knauf
System Management

fon: +49 (0)89 - 51 555 878
fax: +49 (0)89 51 555 877

*LIGA_01 | M=DCNCHEN

*LIGA_01 COMPUTERFILM GmbH *| *Landwehrstrasse 60-62 *| *80336 Munich, =

Germany
fon: +49 (0)89 51 555 888 *|* fax: +49 (0)89 51 555 877 *| *www.liga01.com

Gesch=E4ftsf=FChrer: Pablo Bach, Justus Engel, Sebastian Faber *|* =

Amtsgericht M=FCnchen HRB 143251 *| *USt-IdNr. DE223186904

*LIGA_01 | HAMBURG

*LIGA_01 COMPUTERFILM HAMBURG GmbH *| *Grosse Theaterstrasse 1 *| *20354 =

Hamburg, Germany
fon: +49 (0)40 226 226 00 *| *fax: +49 (0) 40 226 226 026 *| *www.liga01.com

Diese Nachricht enth=E4lt vertrauliche und/oder rechtlich gesch=FCtzte =

Informationen. Wenn Sie nicht der richtige Adressat sind oder diese =

Nachricht irrt=FCmlich erhalten haben, informieren Sie bitte den Absender =

und l=F6schen diese Nachricht. Das unerlaubte Kopieren und die unbefugte =

Weiterleitung dieser Nachricht sind nicht gestattet.

This message may contain confidential and/or privileged information. If =

you are not the intended recipient or if you have received this message =

in error, please notify the sender and delete this message. Any =

unauthorised copying, disclosure or distribution of this message is =

strictly forbidden.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
