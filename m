Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q36BCPeP196854 for <xfs@oss.sgi.com>; Fri, 6 Apr 2012 06:12:26 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id xrBtErGAMnN8DzbT
	for <xfs@oss.sgi.com>; Fri, 06 Apr 2012 04:12:24 -0700 (PDT)
Message-ID: <4F7ECF97.6020601@hardwarefreak.com>
Date: Fri, 06 Apr 2012 06:12:23 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: RAID5 created by 8 disks works with xfs
References: <CACwgYDPQBNa7z7WcyUjV2Rx8Qf47r7eaRCowNKxjLBz+fYcfvQ@mail.gmail.com>
	<4F77EA55.6090004@hardwarefreak.com>
	<CACwgYDMVHT5DFjJztX9JvsVQJ+uOjPrfcs4+0aGXotDvf6tymQ@mail.gmail.com>
	<CACwgYDMXF9WEgzW9vL_0=GdRc_t+67WAkRTKNoKOMEMCvjujVw@mail.gmail.com>
	<CALFpzo5aKM2y_stDR14PNYMHEcq5CEptuFiXrvcCpXTzSQmAxw@mail.gmail.com>
	<4F792154.5020006@hardwarefreak.com>
	<CACwgYDPsZSEhuqNP8YgAksEq9BB6YOS1Q8jGx2J7DCrrOh_JQw@mail.gmail.com>
	<CACwgYDOtCoVF-p+KKqPYxHhA4vWF78Ueecx9hcVWLoyxFWzV9Q@mail.gmail.com>
	<4F7E0842.6090004@hardwarefreak.com>
	<CACwgYDMEpFqJhtUGeRg4hvux3GigNRnA--V18DwdyUvJpY434w@mail.gmail.com>
	<CACwgYDPur_8sO-BhhP-ggEmPCGa5ddsCcmSDfCuhD9OgiwGRyw@mail.gmail.com>
	<CA+res+RR5iAZsEY8G21YkQn+p_8EYSFvu4+H1SK=HXshOcS-4g@mail.gmail.com>
	<CACwgYDN5ceD3ka-O9t1rGdj4tS=JpHVm_ZWetqZ7ZAOyEjqspA@mail.gmail.com>
	<CACwgYDOc2C=j1hrbtwTqOPr77wtfLvxow9xNeF+mGUakt1rHzQ@mail.gmail.com>
	<4F7EA6D4.804@hardwarefreak.com>
	<CACwgYDMXZ2O+7B163eg5h-D5sw9_0MRgu8BAahjgOr+td8cJtg@mail.gmail.com>
In-Reply-To: <CACwgYDMXZ2O+7B163eg5h-D5sw9_0MRgu8BAahjgOr+td8cJtg@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: daobang wang <wangdb1981@gmail.com>
Cc: Marcus Sorensen <shadowsor@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>, Jack Wang <jack.wang.usish@gmail.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 4/6/2012 3:45 AM, daobang wang wrote:
> Hi stan,
> 
>     Thank you for your reply, the envrionment is the same that i
> mentioned before,  [...]

There's seems to be some kind of communication failure here.  I'll make
this really simple.  Please fill in the blanks.

$ uname -a

$ xfs_info [device]

$ cat /etc/fstab|grep xfs

$ mdadm --detail /dev/mdX


Thanks.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
