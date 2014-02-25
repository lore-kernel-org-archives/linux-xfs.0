Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C033A7F50
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 11:17:33 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 81CD08F806F
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 09:17:33 -0800 (PST)
Received: from mail1.g1.pair.com (mail1.g1.pair.com [66.39.3.162]) by
	cuda.sgi.com with ESMTP id EgQrgROXrv9RvHPD for
	<xfs@oss.sgi.com>; Tue, 25 Feb 2014 09:17:31 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by mail1.g1.pair.com (Postfix) with SMTP id F25A62CB25
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 12:17:30 -0500 (EST)
Received: from harpe.intellique.com (labo.djinux.com [82.225.196.72])
	by mail1.g1.pair.com (Postfix) with ESMTPSA id 50D8D2CCB9
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 12:17:30 -0500 (EST)
Date: Tue, 25 Feb 2014 18:17:31 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Question regarding XFS on LVM over hardware RAID.
Message-ID: <20140225181731.1506b7f7@harpe.intellique.com>
In-Reply-To: <1393347755-sup-205@al.wesleyan.edu>
References: <52E91923.4070706@sandeen.net> <52EB3B96.7000103@hardwarefreak.com>
	<1391202273-sup-9265@al.wesleyan.edu>
	<52ED61C9.8060504@hardwarefreak.com>
	<20140202212152.GP2212@dastard>
	<1391443675-sup-1730@al.wesleyan.edu>
	<20140203214128.GR13997@dastard>
	<52F09E36.8050606@hardwarefreak.com>
	<1392748390-sup-1943@al.wesleyan.edu>
	<5303E7AC.50903@hardwarefreak.com>
	<20140220183125.29149.64880@al.wesleyan.edu>
	<5306C90B.1000904@hardwarefreak.com>
	<20140221095742.0ca161b0@galadriel.home>
	<530809A7.70900@hardwarefreak.com>
	<1393347755-sup-205@al.wesleyan.edu>
Mime-Version: 1.0
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
To: xfs@oss.sgi.com

Le Tue, 25 Feb 2014 12:04:10 -0500
"C. Morgan Hamill" <chamill@wesleyan.edu> =E9crivait:

> On this note, I'm using an Areca ARC-1882.  I've been looking for
> documentation regarding concatenation with this, and having a bit of
> trouble.
> =


Unless Areca cards changed a lot in capabilities recently, it's not
possible at all. You can expand a RAID set but it's generally a bad
idea.

-- =

------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
