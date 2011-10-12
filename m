Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9C1NhDI031698 for <xfs@oss.sgi.com>; Tue, 11 Oct 2011 20:23:44 -0500
Received: from mail-ey0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E13641BD457
	for <xfs@oss.sgi.com>; Tue, 11 Oct 2011 18:23:42 -0700 (PDT)
Received: from mail-ey0-f181.google.com (mail-ey0-f181.google.com
	[209.85.215.181]) by cuda.sgi.com with ESMTP id
	lKmTkznutfLLFp0y for <xfs@oss.sgi.com>;
	Tue, 11 Oct 2011 18:23:42 -0700 (PDT)
Received: by eyx24 with SMTP id 24so267574eyx.26
	for <xfs@oss.sgi.com>; Tue, 11 Oct 2011 18:23:41 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 11 Oct 2011 18:23:41 -0700
Message-ID: <CADDFK--585nmGJMuVhbhyO5S7tvCxR0Ur_1qxX73AvpAgau8Ew@mail.gmail.com>
Subject: Help with xfs and Fedora 8
From: Ram Natarajan <ram@arohisystems.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7843725816445266085=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============7843725816445266085==
Content-Type: multipart/alternative; boundary=0016364c72b5d220d204af0fdf6f

--0016364c72b5d220d204af0fdf6f
Content-Type: text/plain; charset=ISO-8859-1

I have a bunch of Fedora 8 machines running Kernel 2.6.23.1.
I am noticing that the xfs partitions on these machines 'freeze up' once in
a while. I have  to manually run xfs_repair on these partitions to get them
going again. Note that SMART does not report any hard disk errors - these
are purely xfs related. I also see some xfs kernel module messages in the
kernel logs. My question is this:
Can I move to the latest xfs by recompiling xfs kernel module and xfs
support code for 2.6.23. For various technical reasons, I cannot move to a
later kernel, but it would be great if I can build the latest xfs modules
and xfs support code for 2.6.23. Does anybody know if this is possible, and
if it is possible, will it work reliably?
Thanks,
Ram

-- 
This message may contain confidential information for the exclusive use of
intended addressee. If you are not the addressee, could you please delete
the mail and attachments from your system and inform the sender?

--0016364c72b5d220d204af0fdf6f
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I have a bunch of Fedora 8 machines running Kernel 2.6.23.1. <br>I am notic=
ing that the xfs partitions on these machines &#39;freeze up&#39; once in a=
 while. I have=A0 to manually run xfs_repair on these partitions to get the=
m going again. Note that SMART does not report any hard disk errors - these=
 are purely xfs related. I also see some xfs kernel module messages in the =
kernel logs. My question is this:<br>
Can I move to the latest xfs by recompiling xfs kernel module and xfs suppo=
rt code for 2.6.23. For various technical reasons, I cannot move to a later=
 kernel, but it would be great if I can build the latest xfs modules and xf=
s support code for 2.6.23. Does anybody know if this is possible, and if it=
 is possible, will it work reliably?<br>
Thanks,<br>Ram<br clear=3D"all"><br>-- <br>This message may contain confide=
ntial information for the exclusive use=20
of intended addressee. If you are not the addressee, could you please=20
delete the mail and attachments from your system and inform the sender?<br>

--0016364c72b5d220d204af0fdf6f--


--===============7843725816445266085==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7843725816445266085==--
