Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D1C8F7F3F
	for <xfs@oss.sgi.com>; Tue, 18 Nov 2014 12:24:49 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5250BAC007
	for <xfs@oss.sgi.com>; Tue, 18 Nov 2014 10:24:46 -0800 (PST)
Received: from mout.web.de (mout.web.de [212.227.17.12]) by cuda.sgi.com with
	ESMTP id hQMNVQfzKHKn2wPB (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 18 Nov 2014 10:24:44 -0800 (PST)
Received: from [10.11.166.169] ([131.188.6.12]) by smtp.web.de (mrweb101) with
	ESMTPSA (Nemesis) id 0Ma2YF-1XXKMQ1hdv-00Lm9O for <xfs@oss.sgi.com>;
	Tue, 18 Nov 2014 19:24:41 +0100
Message-ID: <546B8EE8.4040903@web.de>
Date: Tue, 18 Nov 2014 19:24:40 +0100
From: Markus <markus.rhonheimer@web.de>
MIME-Version: 1.0
Subject: Re: Virtual Block device resize corrupts XFS
References: <5468FC60.10901@web.de>
In-Reply-To: <5468FC60.10901@web.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1596525676802052445=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--===============1596525676802052445==
Content-Type: multipart/alternative;
 boundary="------------000501090300030804080705"

This is a multi-part message in MIME format.
--------------000501090300030804080705
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I am in a foreign country right now, but I will be back next week, will 
write all information down as soon as I am back.

kind regards

Markus

Am 16.11.2014 um 20:34 schrieb Markus Rhonheimer:
> Hi,
>
> I am running Centos 7 and have created a virtual block device with ZFS 
> (ZVOL). I put XFS onto the block device without partitioning it.
>
> This worked very well as storage disk for a VM.
>
> A few days ago I wanted to increase the size of the block device, but 
> accidently decreased it by 1 TB (from 7 to 6). I found out about it 
> and immediately increased the size of the drive to 8 TB afterward.
>
> The XFS partition can still be mounted and I can list the files on it, 
> but xfs_repair -n says: "/Sorry/, /could not find valid secondary 
> superblock"
>
> /Is there the possibility to rescue some files?
>
> kind regards
>
> Markus
>
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs


--------------000501090300030804080705
Content-Type: text/html; charset=windows-1252
Content-Transfer-Encoding: 7bit

<html>
  <head>
    <meta content="text/html; charset=windows-1252"
      http-equiv="Content-Type">
  </head>
  <body text="#000000" bgcolor="#FFFFFF">
    <div class="moz-cite-prefix">Hi,<br>
      <br>
      I am in a foreign country right now, but I will be back next week,
      will write all information down as soon as I am back.<br>
      <br>
      kind regards<br>
      <br>
      Markus<br>
      <br>
      Am 16.11.2014 um 20:34 schrieb Markus Rhonheimer:<br>
    </div>
    <blockquote cite="mid:5468FC60.10901@web.de" type="cite">
      <meta http-equiv="content-type" content="text/html;
        charset=windows-1252">
      Hi,<br>
      <br>
      I am running Centos 7 and have created a virtual block device with
      ZFS (ZVOL). I put XFS onto the block device without partitioning
      it.<br>
      <br>
      This worked very well as storage disk for a VM.<br>
      <br>
      A few days ago I wanted to increase the size of the block device,
      but accidently decreased it by 1 TB (from 7 to 6). I found out
      about it and immediately increased the size of the drive to 8 TB
      afterward.<br>
      <br>
      The XFS partition can still be mounted and I can list the files on
      it, but xfs_repair -n says: "<span class="st"><em>Sorry</em>, <em>could

          not find valid secondary superblock"<br>
          <br>
        </em>Is there the possibility to rescue some files?<br>
        <br>
        kind regards<br>
        <br>
        Markus<br>
      </span> <br>
      <fieldset class="mimeAttachmentHeader"></fieldset>
      <br>
      <pre wrap="">_______________________________________________
xfs mailing list
<a class="moz-txt-link-abbreviated" href="mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a>
<a class="moz-txt-link-freetext" href="http://oss.sgi.com/mailman/listinfo/xfs">http://oss.sgi.com/mailman/listinfo/xfs</a>
</pre>
    </blockquote>
    <br>
  </body>
</html>

--------------000501090300030804080705--


--===============1596525676802052445==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1596525676802052445==--
