Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4PEm40K129588 for <xfs@oss.sgi.com>; Fri, 25 May 2012 09:48:04 -0500
Received: from mail-pz0-f53.google.com (mail-pz0-f53.google.com
	[209.85.210.53]) by cuda.sgi.com with ESMTP id lhAbC3IsctP6OabH
	(version=TLSv1 cipher=RC4-MD5 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 25 May 2012 07:48:02 -0700 (PDT)
Received: by dadg9 with SMTP id g9so1636339dad.26
	for <xfs@oss.sgi.com>; Fri, 25 May 2012 07:48:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FBF63B0.6020209@gmail.com>
References: <4FBF60D1.80104@gmail.com> <4FBF62D2.20702@fastmail.fm>
	<4FBF63B0.6020209@gmail.com>
Date: Fri, 25 May 2012 11:48:01 -0300
Message-ID: <CABYL=Toi+Mbm1nJ=5HhBnjYiK9ZEL-SYmwe3aLtm5CzTdR8zcg@mail.gmail.com>
Subject: Re: very slow file deletion on an SSD
From: Roberto Spadim <roberto@spadim.com.br>
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
To: Joe Landman <joe.landman@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Bernd Schubert <bernd.schubert@fastmail.fm>, xfs@oss.sgi.com

noop scheduler could be better for ssd?

2012/5/25 Joe Landman <joe.landman@gmail.com>:
> On 05/25/2012 06:45 AM, Bernd Schubert wrote:
>>
>> Hello Joe,
>>
>> On 05/25/2012 12:37 PM, Joe Landman wrote:
>>>
>>> Hi folks:
>>>
>>> Just ran into this (see posted output at bottom). 3.2.14 kernel, MD RAID
>>> 5, xfs file system. Not sure (precisely) where the problem is, hence
>>> posting to both lists.
>>
>>
>> do you have anything enabled, that would make your files to have xattrs?
>
>
> Not to my knowledge. =A0I'll go back and re-create some files and see.
>
>> http://oss.sgi.com/archives/xfs/2011-08/msg00233.html
>
>
> Hmmm
>
>
>
> --
> Joseph Landman, Ph.D
> Founder and CEO
> Scalable Informatics Inc.
> email: landman@scalableinformatics.com
> web =A0: http://scalableinformatics.com
> =A0 =A0 =A0 http://scalableinformatics.com/sicluster
> phone: +1 734 786 8423 x121
> fax =A0: +1 866 888 3112
> cell : +1 734 612 4615
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



-- =

Roberto Spadim
Spadim Technology / SPAEmpresarial

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
