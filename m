Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C38597F37
	for <xfs@oss.sgi.com>; Wed,  8 Jul 2015 23:49:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AFE518F8035
	for <xfs@oss.sgi.com>; Wed,  8 Jul 2015 21:48:57 -0700 (PDT)
Received: from mail-qk0-f181.google.com (mail-qk0-f181.google.com
	[209.85.220.181]) by cuda.sgi.com with ESMTP id
	3cX8Z66wvZFbnPbv (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 08 Jul 2015 21:48:56 -0700 (PDT)
Received: by qkhu186 with SMTP id u186so178976868qkh.0
	for <xfs@oss.sgi.com>; Wed, 08 Jul 2015 21:48:55 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 9 Jul 2015 10:18:55 +0530
Message-ID: <CAMcfJ7sZaLwO7Gz8f7E9GBrX75Ddc8JvLntPRpjw=KPNOV7TLg@mail.gmail.com>
Subject: Re: regarding journaling mode
From: Rakesh Patel <patelrakeshcomp@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4259953531764977447=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============4259953531764977447==
Content-Type: multipart/alternative; boundary=001a1146fabe0a5467051a69f9e7

--001a1146fabe0a5467051a69f9e7
Content-Type: text/plain; charset=UTF-8

https://www.kernel.org/doc/Documentation/filesystems/ext4.txt

data=writeback		Data ordering is not preserved, data may be written
			into the main file system after its metadata has been
			committed to the journal.


Rakesh

--001a1146fabe0a5467051a69f9e7
Content-Type: text/html; charset=UTF-8

<div dir="ltr"><a href="https://www.kernel.org/doc/Documentation/filesystems/ext4.txt">https://www.kernel.org/doc/Documentation/filesystems/ext4.txt</a><br><br><pre>data=writeback		Data ordering is not preserved, data may be written
			into the main file system after its metadata has been
			committed to the journal.<br><br><br></pre><pre>Rakesh<br></pre><br></div>

--001a1146fabe0a5467051a69f9e7--


--===============4259953531764977447==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4259953531764977447==--
