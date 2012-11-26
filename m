Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAQ7EtFa161481 for <xfs@oss.sgi.com>; Mon, 26 Nov 2012 01:14:55 -0600
Received: from mail-vc0-f181.google.com (mail-vc0-f181.google.com
	[209.85.220.181]) by cuda.sgi.com with ESMTP id
	5pN8fI5UMFJQY3yw (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 25 Nov 2012 23:17:09 -0800 (PST)
Received: by mail-vc0-f181.google.com with SMTP id fy27so5996875vcb.26
	for <xfs@oss.sgi.com>; Sun, 25 Nov 2012 23:17:08 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 26 Nov 2012 12:47:08 +0530
Message-ID: <CAB+GMR8yU4LaU7EwXboKQLDsGGD0N6EuDT4CgxYLpVFPsROKXg@mail.gmail.com>
Subject: Project quota behaviour on hardlinks
From: Varun Shastry <vrn.shastry@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2358279628486992088=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============2358279628486992088==
Content-Type: multipart/alternative; boundary=14dae9cdc529a5de0104cf60b854

--14dae9cdc529a5de0104cf60b854
Content-Type: text/plain; charset=ISO-8859-1

Hello everyone,

I wanted to know how project quota behaves on hardlinks when created in
different tree structures based on below 2 situations.

* Does it account twice if the file is hard linked in the same parent?
* Does it account twice if the file is hard linked in a different tree
which is also set quota in other project?

Any links to this documentation or direct answer is requested.

And pardon me for previous mail.

Thanks
Varun Shastry

--14dae9cdc529a5de0104cf60b854
Content-Type: text/html; charset=ISO-8859-1

Hello everyone,<br><br>I wanted to know how project quota behaves on hardlinks when created in different tree structures based on below 2 situations.<br><br>* Does it account twice if the file is hard linked in the same parent?<br>

* Does it account twice if the file is hard linked in a different tree which is also set quota in other project?<br><br>Any links to this documentation or direct answer is requested.<br><br>And pardon me for previous mail.<br>
<br>Thanks<br>
Varun Shastry<br>

--14dae9cdc529a5de0104cf60b854--


--===============2358279628486992088==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2358279628486992088==--
