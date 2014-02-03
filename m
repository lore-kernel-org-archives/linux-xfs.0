Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6D70A7FCA
	for <xfs@oss.sgi.com>; Mon,  3 Feb 2014 01:14:19 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 30E88304043
	for <xfs@oss.sgi.com>; Sun,  2 Feb 2014 23:14:19 -0800 (PST)
Received: from mail-qa0-f53.google.com (mail-qa0-f53.google.com
	[209.85.216.53]) by cuda.sgi.com with ESMTP id ZuGFtB0cJU7S0mKl
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 02 Feb 2014 23:14:14 -0800 (PST)
Received: by mail-qa0-f53.google.com with SMTP id cm18so9324141qab.26
	for <xfs@oss.sgi.com>; Sun, 02 Feb 2014 23:14:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <83F9F221-9387-47D5-B67C-E9252056E408@colorremedies.com>
References: <CAMN6oR=a0G6O-3CVVkTwhYKavJTa543U3MLezCM8KW1ASZcPnA@mail.gmail.com>
	<52EB64DC.4020603@oracle.com> <1391165083.4275.7.camel@ubuntu>
	<52EB960D.607@oracle.com> <1391172723.4275.11.camel@ubuntu>
	<52EBA783.1080801@oracle.com> <1391178074.4275.19.camel@ubuntu>
	<52EBB431.50301@oracle.com>
	<6C94A326-DADE-4A32-97F6-AE84E9F57777@gmail.com>
	<1D87A7C9-988F-4F61-A577-67300DAF2554@dubeyko.com>
	<14FE2575-4C84-43B8-9992-F91ABE2B6F26@gmail.com>
	<83F9F221-9387-47D5-B67C-E9252056E408@colorremedies.com>
Date: Mon, 3 Feb 2014 08:14:13 +0100
Message-ID: <CAMN6oR=c3o5ayAdG010mh=9AZu0EbkU_zR4FptFA_egnbqt=8Q@mail.gmail.com>
Subject: Re: Extended attributes limit in Linux
From: Sun_Blood <sblood@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7524418791325410917=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Chris Murphy <lists@colorremedies.com>
Cc: xfs@oss.sgi.com

--===============7524418791325410917==
Content-Type: multipart/alternative; boundary=001a11c1475e55401d04f17b45bb

--001a11c1475e55401d04f17b45bb
Content-Type: text/plain; charset=ISO-8859-1

On Mon, Feb 3, 2014 at 2:15 AM, Chris Murphy <lists@colorremedies.com>wrote:

>
> On Feb 2, 2014, at 7:33 AM, Sun_Blood <sblood@gmail.com> wrote:
> > I will make a bug report for rsync also that it should not try to copy
> files with EA bigger then the destination can handle. But it would be great
> if XFS could handle this files and be fully compatible with OS X backups.
>
> What application(s) are creating such files on OS X? Or how are they
> coming to have such large extended attributes?
>
>
> Chris Murphy


They are created by Adobe Photoshop and/or iPhoto.

/Martin

--001a11c1475e55401d04f17b45bb
Content-Type: text/html; charset=ISO-8859-1

<div dir="ltr"><div class="gmail_extra"><br><div class="gmail_quote">On Mon, Feb 3, 2014 at 2:15 AM, Chris Murphy <span dir="ltr">&lt;<a href="mailto:lists@colorremedies.com" target="_blank">lists@colorremedies.com</a>&gt;</span> wrote:<br>
<blockquote class="gmail_quote" style="margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex"><div class="im"><br>
On Feb 2, 2014, at 7:33 AM, Sun_Blood &lt;<a href="mailto:sblood@gmail.com">sblood@gmail.com</a>&gt; wrote:<br>
&gt; I will make a bug report for rsync also that it should not try to copy files with EA bigger then the destination can handle. But it would be great if XFS could handle this files and be fully compatible with OS X backups.<br>

<br>
</div>What application(s) are creating such files on OS X? Or how are they coming to have such large extended attributes?<br>
<span class=""><font color="#888888"><br>
<br>
Chris Murphy</font></span></blockquote></div><br>They are created by Adobe Photoshop and/or iPhoto.<br><br></div><div class="gmail_extra">/Martin<br></div></div>

--001a11c1475e55401d04f17b45bb--


--===============7524418791325410917==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7524418791325410917==--
